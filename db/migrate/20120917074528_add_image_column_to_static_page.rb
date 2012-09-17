class AddImageColumnToStaticPage < ActiveRecord::Migration
  def change
    add_column :static_pages, :picture_uid, :string
    add_column :static_pages, :picture_name, :string
  end
end
