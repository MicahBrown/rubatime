class DashboardController < ApplicationController
  def index
    @logs = Log.order("start_at DESC").page(params[:page]).per(50)
  end
end
