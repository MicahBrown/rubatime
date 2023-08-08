class CreateSavedFilters < ActiveRecord::Migration[7.0]
  def change
    create_table :saved_filters do |t|
      t.string :controller, null: false
      t.string :action, null: false
      t.text :filters
      t.timestamps null: false
    end
  end
end
