class ChangeStaticPagesRenameColumnNameToSlug < ActiveRecord::Migration
  def change
    rename_column :static_pages, :name, :slug
  end
end
