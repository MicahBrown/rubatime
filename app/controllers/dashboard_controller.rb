class DashboardController < ApplicationController
  def index
    @logs = Log.order("start_at DESC")
  end
end
