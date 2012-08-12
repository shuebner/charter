class CreateParagraphs < ActiveRecord::Migration
  def change
    create_table :paragraphs do |t|
      t.string :heading
      t.text :text
      t.integer :order, null: false
      t.references :static_page, null: false

      t.timestamps
    end
    add_index :paragraphs, :static_page_id
    add_index :paragraphs, :order
  end
end
