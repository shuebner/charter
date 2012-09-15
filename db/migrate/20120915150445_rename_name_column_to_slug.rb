class RenameNameColumnToSlug < ActiveRecord::Migration
  def up
    rename_column :static_pages, :name, :slug
  end

  def down
    rename_column :static_pages, :slug, :name
  end
end
