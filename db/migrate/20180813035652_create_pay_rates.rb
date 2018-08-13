class CreatePayRates < ActiveRecord::Migration[5.2]
  def change
    create_table :pay_rates do |t|
      t.date :effective_start_date, null: false
      t.date :effective_end_date
      t.decimal :rate, precision: 5, scale: 2
      t.boolean :current, null: false, default: true
      t.timestamps null: false
    end
  end
end
