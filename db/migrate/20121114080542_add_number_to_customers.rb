class AddNumberToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :number, :integer
    Customer.all.each { |c| c.save }    
    change_column :customers, :number, :integer, null: false, unique: true
    add_index :customers, :number, unique: true    
  end

  def self.down
    remove_column :customers, :number
  end
end
