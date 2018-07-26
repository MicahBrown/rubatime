module LogsHelper
  def hours_by_weeks(number_of_weeks, start_at: Date.today)
    last_week_start = start_at.next_week.in_time_zone(TIMEZONE).beginning_of_week
    weeks = {}

    number_of_weeks.times do |x|
      week_end = (last_week_start - 1.second)
      week_start = week_end.beginning_of_week

      weeks[x] = {label: week_label(week_start, week_end), hours: 0}

      logs = Log.in_datetime_range(week_start, week_end).active.order("start_at ASC, end_at ASC")
      logs.each do |log|
        start_time = log.start_at.in_time_zone(TIMEZONE)
        start_time = week_start if start_time < week_start
        end_time = log.end_at.in_time_zone(TIMEZONE)
        end_time = week_end if end_time > week_end

        weeks[x][:hours] += week_hours(start_time, end_time)
      end

      last_week_start = week_start
    end

    weeks
  end

  private

    def week_hours(start_time, end_time)
      seconds = end_time - start_time
      hours = seconds / 60.0 / 60
      hours.round(2)
    end

    def week_label(week_start, week_end)
      if week_start.month != week_end.month
        "#{week_start.strftime("%b %-e")} - #{week_end.strftime("%b %-e")}"
      else
        "#{week_start.strftime("%b %-e")} - #{week_end.strftime("%-e")}"
      end
    end
end
