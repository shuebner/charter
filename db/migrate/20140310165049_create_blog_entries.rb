class CreateBlogEntries < ActiveRecord::Migration
  def change
    create_table :blog_entries do |t|
      t.string :heading
      t.string :slug
      t.text :text
      t.boolean :active

      t.timestamps
    end
    add_index :blog_entries, :slug
  end
end
