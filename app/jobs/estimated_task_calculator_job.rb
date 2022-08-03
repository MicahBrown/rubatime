class EstimatedTaskCalculatorJob < ApplicationJob
  queue_as :default

  def perform
    et = EstimatedTax.last || EstimatedTax.new
    today = Date.today
    start_at = today.in_time_zone(TIMEZONE).beginning_of_year
    end_at = today.in_time_zone(TIMEZONE).end_of_year
    logs = Log.in_datetime_range(start_at, end_at)

    max_rate = PayRate.maximum(:rate)
    et.update!(value: (((logs.pluck(:elapsed_seconds).inject(:+) / 60 / 60) * max_rate) * 0.3))
  end
end
