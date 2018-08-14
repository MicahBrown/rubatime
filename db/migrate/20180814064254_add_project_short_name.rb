class AddProjectShortName < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :short_name, :string
    update("UPDATE projects SET short_name = name")
    change_column_null :projects, :short_name, false
  end
end
