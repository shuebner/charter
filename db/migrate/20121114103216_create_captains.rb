class CreateCaptains < ActiveRecord::Migration
  def change
    create_table :captains do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :slug, null: false, unique: true
      t.string :phone, null: false
      t.string :email
      t.string :sailing_certificates
      t.string :additional_certificates
      t.text :description

      t.timestamps
    end
    add_index :captains, :slug, unique: true
  end
end
