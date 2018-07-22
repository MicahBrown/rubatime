class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.belongs_to :project, foreign_key: true
      t.datetime :start_at, null: false
      t.datetime :end_at
      t.decimal :elapsed_seconds, precision: 10, scale: 2
      t.text :description
      t.boolean :active, null: false, default: false
      t.timestamps null: false
    end
  end
end
