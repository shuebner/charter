class MakeInquiriesBaseTableForCitier < ActiveRecord::Migration
  def change
    add_column :inquiries, :type, :string
  end
end
