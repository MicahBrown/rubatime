class CreateEstimatedTaxes < ActiveRecord::Migration[5.2]
  def change
    create_table :estimated_taxes do |t|
      t.decimal :value, null: false, default: 0, precision: 8, scale: 2
      t.timestamps null: false
    end
  end
end
