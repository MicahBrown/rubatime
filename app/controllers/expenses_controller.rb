class ExpensesController < ApplicationController
  def index
    @expenses = Expense.order("expense_date DESC")
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)

    respond_to do |format|
      if @expense.save
        format.html { redirect_to expenses_path, notice: "Successfully created expense!" }
      else
        format.js
      end
    end
  end

  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy!

    redirect_to expenses_path, notice: "Successfully deleted expense!"
  end

  private

    def expense_params
      params.require(:expense).permit(:category, :amount, :expense_date)
    end
end
