class DashboardController < ApplicationController
  before_action :load_and_save_filters

  def index
    @start_date = params[:filtered_start_date]&.to_date || (2.months.ago.beginning_of_month + 1.day)
    @end_date = params[:filtered_end_date]&.to_date&.end_of_day || Date.today.end_of_month

    @logs = Log.in_datetime_range_or_pending(@start_date, @end_date).page(params[:page]).per(50)
  end
end
