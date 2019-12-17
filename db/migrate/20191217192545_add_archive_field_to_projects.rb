class AddArchiveFieldToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :archived_at, :datetime
  end
end
