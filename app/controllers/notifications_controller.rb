class NotificationsController < ApplicationController
  before_action :get_notification_count

  def index
    @meta = { title: "Notifications" }
  end

  def read
    query = auth_hash
    @notifications = lnp_api_json("mark_read_notifications", query)
    @notifications_count = @notifications["notification_count"].to_s
    if @notifications["errors"].present?
      redirect_to notifications_path, notice: "Sorry, marking channel as open failed. Error(s): " + humanize_errors(@notifications)
    else
      redirect_to notifications_path, notice: "Marking channel as open was successful."
    end
  end

end