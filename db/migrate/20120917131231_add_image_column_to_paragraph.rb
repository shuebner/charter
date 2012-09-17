class AddImageColumnToParagraph < ActiveRecord::Migration
  def change
    add_column :paragraphs, :picture_uid, :string
    add_column :paragraphs, :picture_name, :string
  end
end
