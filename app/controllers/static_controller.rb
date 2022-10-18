class StaticController < ApplicationController
  before_action :get_notification_count, only: %i[ home ]

  def home
    @meta = { title: "Home" }
  end

  def features
    @meta = { title: "Features" }
  end

  def legal
    @meta = { title: "Legal" }
  end

  def about
    @meta = { title: "About" }
  end
end
