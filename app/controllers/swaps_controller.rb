class SwapsController < ApplicationController

  # latest 50 swaps
  def index
    @meta = { title: "Swaps Index" }
    response = HTTParty.get(api_url("get_swaps"), headers: headers_hash)
    @json = JSON.parse(response.body)
  end

  def show
    url = api_url("get_swap/id=" + params[:id].to_s)
    response = HTTParty.get(url, headers: headers_hash)
    @swap = JSON.parse(response.body)
    @participant_max_count = @swap["participant_max_count"]
    @swap_identifiers = helpers.identifiers(@participant_max_count)
    @image_webp = helpers.shape_image(@swap["capacity_sats"], @participant_max_count, "webp", "full")
    @image_jpg = helpers.shape_image(@swap["capacity_sats"], @participant_max_count, "jpg", "full")
    @shape = helpers.shape(@participant_max_count)
    @image_alt = @shape + " shape over clouds"
    @status_color = helpers.status_color(@swap["status"])
    @swap_status = @swap["status"]
    @humanized_swap_status = helpers.humanize_swap_status(@swap_status)
    @swap_is_dual = @participant_max_count == 2
    @participants = @swap["participants"]
    @pubkey = get_pubkey.identity_pubkey unless get_pubkey.nil? # user's pubkey
    
    # .present? == true if node is part of swap
    @participant = @participants.select { |p| p["pubkey"] == @pubkey }.first
    
    def find_participant(participants, identifier)
      participants.select{|p| p["participant_identifier"] == identifier}.first
    end
    
    if @participant.present?
      @participant_has_tor = @participant["address_1"].include?("onion") || @participant["address_2"].include?("onion")
      @opening_to_participant_identifier = @participant["opening_to_participant_identifier"]
      @opening_to_participant = helpers.find_participant(@participants, @opening_to_participant_identifier)
      @receiving_from_participant_identifier = @participant["receiving_from_participant_identifier"]
      @receiving_from_participant = helpers.find_participant(@participants, @receiving_from_participant_identifier)
    else
      @participant_has_tor = nil
    end
    
    # Looking up if channel already exists
    if @swap_status == "opening" && @participant.present? && @participant["application_status"] == "opening"
      @opening_to_participant_channel_exists = channel_exists(@opening_to_participant["pubkey"])
    end
    
    # Check if peering is necessary
    if @receiving_from_participant.present?
      @receiving_from_participant_has_tor = @receiving_from_participant["address_1"].include?("onion") || @receiving_from_participant["address_2"].include?("onion")
    else
      @receiving_from_participant_has_tor = nil
    end
    
    # Required only if swap is open for application
    if @swap_status == "pending" && !@participant.present?
      @can_apply = true
      @node_info = get_node_info(@pubkey)
      if @swap["participant_min_channels_count"].present? && @swap["participant_min_channels_count"] > @node_info[:num_channels]
        @can_apply = false
      end
      if @swap["participant_min_capacity_sats"].present? && @swap["participant_min_capacity_sats"] > @node_info[:total_capacity]
        @can_apply = false
      end
      if get_chain_balance < @swap["capacity_sats"]
        @can_apply = false
      end
    end
    
    # check if user is connected already to participants
    if @swap_status == "pending" && !@participant.present? && @can_apply
      @connected_pubkeys = connected_pubkeys(@participants)
    end

    @meta = {
      title: @shape.capitalize + " Swap ID: " + @swap["id"].to_s,
      image: @image_jpg
    }
  end
  
  def for_me
    @meta = { title: "Swaps Open For Me" }
    @json = lnp_api_json("get_applicable_swaps", auth_hash)
  end
  
  def my_swaps
    @meta = { title: "My Swaps" }
    @json = lnp_api_json("get_my_swaps", auth_hash)
    if @json.present?
      @json_pending = @json.first["pending"]
      @json_opening = @json.first["opening"]
      @json_completed = @json.first["completed"]
    end
  end

  def to_dos
    @meta = { title: "To Dos" }
    @json = lnp_api_json("get_my_todos", auth_hash)
    @json_opening = @json.first["opening"] if @json.present?
  end

  def auto_verify_signature
    @json = lnp_api_json("verify_signature", auth_hash)
  end

  def new
    @meta = { title: "Create New Swap" }
  end

  def create   
    query_params = {
      'participants' => params[:participants],
      'capacity' => params[:capacity],
      'duration' => params[:duration],
      'min_channels' => params[:min_channels],
      'min_capacity' => params[:min_capacity],
      'rules' => params[:rules]
    }
    query = auth_hash.merge(query_params)
    @json = lnp_api_json("create_swap", query)
    if @json["errors"].present?
      redirect_to "/swaps", notice: "Sorry, swap creation failed. Error(s): " + humanize_errors(@json)
    else
      redirect_to "/swaps/" + @json["id"].to_s, notice: "Swap was successfully created."
    end
  end

end
