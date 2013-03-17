class AllowNullOnAttachmentOrder < ActiveRecord::Migration
  def up
    change_column :attachments, :order, :integer, null: true
  end

  def down
    change_column :attachments, :order, :integer, null: false
  end
end
