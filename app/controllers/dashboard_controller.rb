class DashboardController < ApplicationController
  def index
    @start_date = params[:filtered_start_date]&.to_date || (2.months.ago.beginning_of_month + 1.day)
    @end_date = params[:filtered_end_date]&.to_date&.end_of_day || Date.today.end_of_month

    @logs = Log.order("start_at DESC").in_datetime_range(@start_date, @end_date).page(params[:page]).per(50)
  end
end
