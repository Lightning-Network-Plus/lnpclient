class ApplicationController < ActionController::Base
  require "httparty"
  require "lnrpc"
  # before_action :get_notification_count

  private
    def get_notification_count
      @notifications = lnp_api_json("get_notifications", auth_hash)
      @notifications_count = @notifications["notification_count"].to_s unless @notifications.nil?
    end

    def lnd_client
      lnd = Lnrpc::Client.new({
        credentials_path: ENV["CERTIFICATE_PATH"],
        macaroon_path: ENV["MACAROON_PATH"],
        address: ENV["LN_SERVER_URL"]
      })
    end

    def node_pubkey(pubkey)
      Lnrpc.to_byte_array(pubkey)
    end

    def peer_exists(pubkey)
      lnd ||= lnd_client
      response = lnd.lightning.list_peers
      response.peers.any? { |peer| peer.pub_key == pubkey }
    end

    def connect_peer(pubkey, host)
      lnd ||= lnd_client
      lnd.lightning.connect_peer(addr: {pubkey: pubkey, host: host})
    rescue => e
      puts "***** PEER ERROR *****"
      puts e
      puts "***** PEER ERROR *****"
    end

    def channel_exists(pubkey)
      lnd ||= lnd_client
      response = lnd.lightning.list_channels
      response.channels.any? { |channel| channel.remote_pubkey == pubkey }
    end

    def connected_pubkeys(participants) # pubkey - user node's pubkey
      matches = Array.new
      participants.each do |participant|
        matches << participant if channel_exists(participant["pubkey"])
      end
      return matches
    end

    def open_channel(pubkey, local_funding_amount)
      lnd ||= lnd_client
      response = lnd.lightning.open_channel({node_pubkey: node_pubkey(pubkey), local_funding_amount: local_funding_amount})
      return {success: true, response: response}
    rescue => e
      puts "***** CHANNEL OPEN ERROR *****"
      puts e
      return {success: false, response: e.to_s}
    end

    def get_pubkey
      begin
        lnd ||= lnd_client
        lnd.lightning.get_info
      rescue => e
        nil
      end
    end

    def get_chain_balance
      lnd ||= lnd_client
      lnd.lightning.wallet_balance.total_balance
    end

    def get_node_info(pubkey)
      lnd ||= lnd_client
      response = lnd.lightning.get_node_info(pub_key: pubkey, include_channels: false)
      {num_channels: response.num_channels, total_capacity: response.total_capacity}
    end

    # get message to sign from the API
    def get_message_hash
      url = api_domain + "get_message"
      headers = { 'Content-Type' => 'application/json', 'X-CSRF-Token' => 'not_required' }
      response = HTTParty.get(url, headers: headers)
      @json = JSON.parse(response.body)
    end

    # sign a message with node
    def get_signature(message)
      lnd ||= lnd_client
      response = lnd.lightning.sign_message({ msg: message })
      response.signature
    end

    # get message + signature hash
    def auth_hash      
      message = get_message_hash["message"]
      signature = get_signature(message)
      {'message' => message, 'signature' => signature}
    end

    def api_domain
      ENV["API_URL"] ||= "https://lightningnetwork.plus/api/2/" # if API_URL not set in environmental variables, the live API is used
    end
  
    def api_url(api_call)
      api_domain + api_call
    end
  
    def headers_hash
      { 'Content-Type' => 'application/json', 'X-CSRF-Token' => 'not_required' }
    end

    def lnp_api_json(api_call, query)
      begin
        response = HTTParty.post( api_url(api_call), query: query, headers: headers_hash )
        JSON.parse(response.body)
      rescue => e
        nil
      end
    end

    def humanize_errors(json)
      error_message = ""
      @json["errors"].each do |key, value|
        error_message = error_message + key + ": " + value.first.to_s + ", "
      end
      error_message
    end

end