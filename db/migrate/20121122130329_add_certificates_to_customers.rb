class AddCertificatesToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :has_sks_or_higher, :boolean
  end
end
