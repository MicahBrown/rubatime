class DashboardController < ApplicationController
  before_action :load_and_save_filters

  def index
    @start_date = params[:filtered_start_date]&.to_date || (Date.today.beginning_of_month)
    @end_date = params[:filtered_end_date]&.to_date&.end_of_day || Date.today.end_of_month
    @all_logs = Log.where(active: true).in_datetime_range(@start_date.in_time_zone(TIMEZONE).beginning_of_day, @end_date.in_time_zone(TIMEZONE).end_of_day)
    @all_logs = @all_logs.where(project_id: params[:filtered_project]) if params[:filtered_project].present?
    @logs = @all_logs.page(params[:page]).ordered.per(50)
  end
end
