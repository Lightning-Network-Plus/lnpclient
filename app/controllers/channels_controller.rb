class ChannelsController < ApplicationController

  def open

    begin
      local_funding_amount = params[:capacity].to_i
      pubkey = params[:address].split("@").first
      host = params[:address].split("@").second

      # peer if not already peered
      puts; puts "🍐 Checking peers:"
      if !peer_exists(pubkey)
        puts "❌ no peer match!"
        puts "Peering..."
        response = connect_peer(pubkey, host)
        peer_exists_boolean = peer_exists(pubkey)
      else
        puts "🙋 peer match!"
        peer_exists_boolean = true
      end

      # if peer is in place, attempt to open a channel
      if peer_exists_boolean
        puts; puts "🛳 Checking channels:"
        if channel_exists(pubkey)
          puts "🙋 channel match!"
          @notice = "It appears the channel already exists. No new channel has been opened."
        else
          puts "❌ no channel match!"
          puts "Opening channel..."
          response = open_channel(pubkey, local_funding_amount) # open channel
          @notice = "Channel opening has been attempted. Please verify the new channel opening has been successful and then click the Channel Opening Started button."
          query = auth_hash.merge({ 'id' => params[:id] })
          # @json = lnp_api_json("complete_application", query) # mark application as channel opening transaction complete
          # puts "✅ Mark application as complete..."
        end
      else
        @notice = "Peering failed, please try opening channel manually."
      end

    rescue => e
      @notice ||= "Sorry, something went wrong. Please try opening channel manually. Error message: " + e.debug_error_string.to_s
    else
      @notice ||= "Sorry, something went wrong."
    ensure
      @lnd_response = response
      redirect_to "/swaps/" + params[:id].to_s, notice: @notice
    end

  end

end
