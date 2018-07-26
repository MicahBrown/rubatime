require 'csv'

class ExportsController < ApplicationController
  def create
    prev_period = Log.previous_pay_period_dates
    logs = Log.in_datetime_range(prev_period.min, prev_period.max).active.order("start_at ASC, end_at ASC")

    respond_to do |format|
      format.csv do
        send_data render_csv(logs, prev_period), filename: "Pay Period - #{Date.today}.csv"
      end
    end
  end

  private

    def render_csv(logs, prev_period)
      max_time = prev_period.max.in_time_zone(TIMEZONE)
      min_time = prev_period.min.in_time_zone(TIMEZONE)

      CSV.generate(headers: false) do |csv|
        logs.includes(:project).each do |log|
          start_time = log.start_at.in_time_zone(TIMEZONE)
          start_time = min_time if start_time < min_time
          end_time = log.end_at.in_time_zone(TIMEZONE)
          end_time = max_time if end_time > max_time

          csv << [log.id, "Micah", log.project.name, "", "", 100, "", "", start_time.to_datetime, start_time.to_date, end_time.to_datetime, hours(start_time, end_time), "FALSE", log.description]
        end
      end
    end

    def hours(start_time, end_time)
      seconds = end_time - start_time
      hours = seconds / 60.0 / 60
      hours.round(2)
    end
end
