class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit ]

  def show
    @meta = { title: "Account" }
  end

  def edit
    @meta = { title: "Edit Account" }
  end

  def update
    query_params = Hash.new
    query_params['email'] = params[:email] unless params[:email] == ""
    query_params['name'] = params[:name] unless params[:name] == ""
    query_params['send_notifications'] = params[:send_notifications] == "1" ? true : false
    query_params['can_connect_to_tor'] = params[:can_connect_to_tor] == "1" ? true : false
    query_params['bio'] = params[:bio]
    query_params['twitter'] = params[:twitter] unless params[:twitter] == ""
    query_params['website'] = params[:website] unless params[:website] == ""
    query = auth_hash.merge(query_params)
    puts "query *****"
    puts query
    @json = lnp_api_json("update_account_info", query)
    if @json["errors"].present?
      redirect_to "/account", notice: "Sorry, account update failed. Error(s): " + humanize_errors(@json)
    else
      redirect_to "/account", notice: "Account was successfully updated."
    end
  end

  private
    def set_account
      query = auth_hash
      @account = lnp_api_json("get_account_info", query)
    end

end