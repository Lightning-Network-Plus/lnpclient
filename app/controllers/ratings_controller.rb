class RatingsController < ApplicationController

  def new
  end

  def create
    query = auth_hash.merge({ 'id' => params[:id], 'rating' => params[:rating] })
    @json = lnp_api_json("create_rating", query)
    if @json["errors"].present?
      redirect_to "/swaps/" + params[:id].to_s, notice: "Sorry, rating failed. Error(s): " + humanize_errors(@json)
    else
      redirect_to "/swaps/" + params[:id].to_s, notice: "Thank you for your rating!"
    end
  end

end
