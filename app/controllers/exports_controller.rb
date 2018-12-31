require 'csv'

class ExportsController < ApplicationController
  def create
    prev_period = Log.current_pay_period_datetimes
    logs = Log.in_datetime_range(prev_period.min, prev_period.max).active.order("start_at ASC, end_at ASC")

    respond_to do |format|
      format.csv do
        send_data render_csv(logs, prev_period), filename: "Pay Period - #{prev_period.min} to #{prev_period.max}.csv"
      end
    end
  end

  private

    def render_csv(logs, prev_period)
      max_time = prev_period.max
      min_time = prev_period.min

      CSV.generate(headers: false) do |csv|
        logs.includes(:project).each do |log|
          start_time = log.start_at.in_time_zone(TIMEZONE)
          start_time = min_time if start_time < min_time
          end_time = log.end_at.in_time_zone(TIMEZONE)
          end_time = max_time if end_time > max_time

          csv << [log.id, "Micah", log.project.name, "", "", 100, "", "", start_time.to_datetime.strftime("%-m/%d/%Y %-l:%M %P"), start_time.to_date, end_time.to_datetime.strftime("%-m/%d/%Y %-l:%M %P"), hours(start_time, end_time), "FALSE", log.description]
        end
      end.encode('WINDOWS-1252', undef: :replace, replace: '')
    end

    def hours(start_time, end_time)
      seconds = end_time - start_time
      hours = seconds / 60.0 / 60
      hours.round(2)
    end
end
