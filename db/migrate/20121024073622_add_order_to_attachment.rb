class AddOrderToAttachment < ActiveRecord::Migration
  def change
    change_table :attachments do |t|
      t.integer :order, null: false
    end
  end
end
