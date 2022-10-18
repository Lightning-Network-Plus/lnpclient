class SubscriptionsController < ApplicationController

  def new
  end

  def create
    query = auth_hash.merge({ 'id' => params[:id] })
    @json = lnp_api_json("create_application", query)
    if @json["errors"].present?
      redirect_to "/swaps/" + params[:id].to_s, notice: "Sorry, the application failed. Error(s): " + humanize_errors(@json)
    else
      redirect_to "/swaps/" + params[:id].to_s, notice: "Application was successful."
    end
  end

  def completed
    query = auth_hash.merge({ 'id' => params[:id] })
    @json = lnp_api_json("complete_application", query)
    if @json["errors"].present?
      redirect_to "/swaps/" + params[:id].to_s, notice: "Sorry, dismissing notifications failed. Error(s): " + humanize_errors(@json)
    else
      redirect_to "/swaps/" + params[:id].to_s, notice: "Channel has been successfully marked as opening."
    end
  end

end
