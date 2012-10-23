class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :type
      t.integer :attachable_id, null: false
      t.string :attachable_type, null: false
      t.string :attachment_name
      t.string :attachment_uid, null: false
      t.string :attachment_title, null: false

      t.timestamps
    end
  end
end
