class PayRatesController < ApplicationController
  def show
    @pay_rates = PayRate.latest
  end

  def new
  end

  def create
    pay_rate = PayRate.new(pay_rate_params)
    pay_rate.save!

    redirect_to pay_rate_path, notice: "Updated pay rate!"
  end

  private

    def pay_rate_params
      params.require(:pay_rate).permit(:rate, :effective_start_date)
    end
end
