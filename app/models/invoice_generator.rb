class InvoiceGenerator
  def self.create!(invoice)
    new(invoice).create
  end

  def initialize(invoice)
    @invoice = invoice
    @pdf = Prawn::Document.new
  end

  def create
    add_content
    tmp_file = render_tmp_file
    @invoice.pdf.attach(io: tmp_file, filename: filename)
    @invoice.update_attributes!(status: :completed)
  end

  private

    def add_content
      @pdf.text("INVOICE", size: 24, style: :bold)

      width  = @pdf.bounds.width
      height = @pdf.bounds.height

      diff = 100

      @pdf.bounding_box([(width / 2) + diff, height], width: (width / 2) - diff, height: 70) do
        # @pdf.stroke_bounds

        @pdf.text "Rubatic LLC", style: :bold, size: 14
        @pdf.text "8965 E Florida Ave 01-102", size: 14
        @pdf.text "Denver, CO 80247", size: 14
        @pdf.text "(785) 410-7302", size: 14
      end


      @pdf.bounding_box([0, height - 50], width:width - 200, height: 135) do
        # @pdf.stroke_bounds

        @pdf.text "For", color: "888888"
        @pdf.move_down 5
        @pdf.text "EnVisage Consulting, Inc.", size: 18
        @pdf.move_down 10

        @pdf.text "Issued Date", color: "888888"
        @pdf.move_down 5
        @pdf.text @invoice.created_at.in_time_zone(TIMEZONE).strftime("%-m/%-e/%Y"), size: 18
        @pdf.move_down 10

        @pdf.text "Invoice #", color: "888888"
        @pdf.move_down 5
        @pdf.text @invoice.id.to_s, size: 18
        @pdf.move_down 10
      end

      @pdf.stroke_color = "888888"

      # top box with description, hours, rates, amount
      @pdf.bounding_box([0, height - 220], width: width, height: 300) do
        @pdf.stroke_bounds

        # left column (description)
        @pdf.bounding_box([0, 300], width: width - 225, height: 300) do
          @pdf.stroke_bounds

          @pdf.move_down 50
          @pdf.text data[:description], align: :center

          @pdf.bounding_box([0, 300], width: width - 225, height: 24) do
            @pdf.stroke_bounds
            @pdf.move_down(8)
            @pdf.text "Description", align: :center, color: "888888"
          end
        end

        # middle left column (hours)
        @pdf.bounding_box([width - 225, 300], width: 65, height: 300) do
          @pdf.stroke_bounds

          @pdf.move_down 50
          @pdf.text to_decimal(hours), align: :center

          @pdf.bounding_box([0, 300], width: 65, height: 24) do
            @pdf.stroke_bounds
            @pdf.move_down(8)
            @pdf.text "Hours", align: :center, color: "888888"
          end
        end

        # middle right column (rate)
        @pdf.bounding_box([width - 160, 300], width: 65, height: 300) do
          @pdf.stroke_bounds

          @pdf.move_down 50
          @pdf.text to_decimal(data[:rate]), align: :center

          @pdf.bounding_box([0, 300], width: 65, height: 24) do
            @pdf.stroke_bounds
            @pdf.move_down(8)
            @pdf.text "Rate", align: :center, color: "888888"
          end
        end

        # right column (amount)
        @pdf.bounding_box([width - 95, 300], width: 95, height: 300) do
          @pdf.stroke_bounds

          @pdf.move_down 50
          @pdf.text currency(total), align: :center

          @pdf.bounding_box([0, 300], width: 95, height: 24) do
            @pdf.stroke_bounds
            @pdf.move_down(8)
            @pdf.text "Amount", align: :center, color: "888888"
          end
        end
      end

      # totals box
      @pdf.bounding_box([0, height - 520], width: width, height: 28) do
        @pdf.stroke_bounds
        @pdf.move_down(8)
        @pdf.text "Total", color: "888888", style: :bold
        @pdf.bounding_box([width - 95, 28], width: 95, height: 28) do
          @pdf.stroke_bounds
          @pdf.move_down(8)
          @pdf.text currency(total), align: :center
        end
      end
    end

    def tmp_file_path
      Rails.root.join("tmp/invoices/#{filename}")
    end

    def filename
      "#{@invoice.id}.pdf"
    end

    def render_tmp_file
      # ensure directory is created
      FileUtils.mkdir_p(File.dirname(tmp_file_path))
      # create pdf file
      @pdf.render_file tmp_file_path
      # return File object
      File.open(tmp_file_path)
    end

    def get_pay_rate!
      rates = @invoice.pay_rates
      raise(ArgumentError, "more than 1 or 0 pay rates found") unless rates.size == 1
      rates.first
    end

    def to_decimal(float)
      pieces = float.round(2).to_s.split(".")
      pieces.first.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse + "." + pieces.last.rjust(2, "0")
    end

    def currency(float)
      "$" + to_decimal(float)
    end

    def hours
      (data[:elapsed_seconds] / 60.0 / 60).round(2)
    end

    def total
      (hours * data[:rate]).round(2)
    end

    def data
      return @data if defined?(@data)

      pay_rate = get_pay_rate!
      start_at = @invoice.start_date.in_time_zone(TIMEZONE)
      end_at = @invoice.end_date.in_time_zone(TIMEZONE)
      logs = Log.in_datetime_range(start_at, end_at)

      elapsed_seconds = logs.map do |log|
        s = log.start_at
        s = start_at if start_at > s
        e = log.end_at
        e = end_at if end_at < e
        e - s
      end.inject(:+)

      description = "#{@invoice.start_date.strftime("%b %-e")} - #{@invoice.end_date.strftime("%b %-e")} Services for #{logs.map(&:project).uniq.map(&:short_name).sort.to_sentence}"

      @data = {
        elapsed_seconds: elapsed_seconds,
        description: description,
        rate: pay_rate.rate
      }
    end
end