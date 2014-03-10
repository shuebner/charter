class CreateBlogCategories < ActiveRecord::Migration
  def change
    create_table :blog_categories do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :blog_categories, :slug
  end
end
