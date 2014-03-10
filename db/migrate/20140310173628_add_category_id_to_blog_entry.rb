class AddCategoryIdToBlogEntry < ActiveRecord::Migration
  def up
    add_column :blog_entries, :blog_category_id, :integer
    add_index :blog_entries, :blog_category_id
  end

  def down
    remove_column :blog_entries, :blog_category_id
  end
end
