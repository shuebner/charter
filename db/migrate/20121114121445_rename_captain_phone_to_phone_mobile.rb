class RenameCaptainPhoneToPhoneMobile < ActiveRecord::Migration
  def change
    rename_column :captains, :phone, :phone_mobile
  end
end
