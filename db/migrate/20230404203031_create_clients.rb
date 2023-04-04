class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :name, index: {unique: true}
      t.timestamps null: false
      t.datetime :archived_at
    end

    add_column :projects, :client_id, :bigint
    add_foreign_key :projects, :clients
  end
end
