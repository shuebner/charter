class CreateBlogEntryComments < ActiveRecord::Migration
  def change
    create_table :blog_entry_comments do |t|
      t.string :author
      t.text :text
      t.references :blog_entry

      t.timestamps
    end
  end
end
