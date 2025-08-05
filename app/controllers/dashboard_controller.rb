class DashboardController < ApplicationController
  before_action :load_and_save_filters

  def index
    @start_date = params[:filtered_start_date]&.to_date || (2.months.ago.beginning_of_month + 1.day)
    @end_date = params[:filtered_end_date]&.to_date&.end_of_day || Date.today.end_of_month

    @logs = Log.where(active: true).in_datetime_range(@start_date, @end_date)
    @logs = @logs.where(project_id: params[:filtered_project]) if params[:filtered_project].present?
    @logs = @logs.page(params[:page]).ordered.per(50)
  end
end
