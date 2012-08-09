class CreateStaticPages < ActiveRecord::Migration
  def change
    create_table :static_pages do |t|
      t.string :name, limit: 30, null: false, unique: true
      t.string :title, limit: 100, null: false
      t.string :heading, limit: 100
      t.text :text

      t.timestamps
    end
  add_index :static_pages, :name
  end
end
