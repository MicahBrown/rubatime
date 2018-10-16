class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.integer :category, null: false
      t.date :expense_date, null: false
      t.decimal :amount, precision: 7, scale: 2
      t.timestamps null: false
    end
  end
end
