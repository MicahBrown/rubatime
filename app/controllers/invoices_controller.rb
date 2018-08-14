class InvoicesController < ApplicationController
  def index
    prev_preriod = Log.previous_pay_period_datetimes
    @invoices = Invoice.order("created_at DESC").page(params[:page])
    @invoice = Invoice.new(start_date: prev_preriod.min, end_date: prev_preriod.max)
  end

  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        @invoice.enqueue!
        format.html { redirect_to invoices_path, notice: "Successfully created invoice!" }
      else
        format.js
      end
    end
  end

  private

    def invoice_params
      params.require(:invoice).permit(:start_date, :end_date)
    end
end
