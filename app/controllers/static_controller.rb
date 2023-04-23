class StaticController < ApplicationController
  before_action :get_notification_count, only: %i[ home ]

  def home
    @meta = { title: "Home" }
  end

  def legal
    @meta = { title: "Legal" }
  end

  def about
    @meta = { title: "About" }
  end

  def error
    @meta = { title: "Error" }
  end
end
