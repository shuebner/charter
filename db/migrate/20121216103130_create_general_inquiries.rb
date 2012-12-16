class CreateGeneralInquiries < ActiveRecord::Migration
  def up
    Inquiry.where("type IS NULL").each do |i|
      i.type = "GeneralInquiry"
      i.save!
    end
  end

  def down
    Inquiry.where(type: "GeneralInquiry").each do |i|
      i.type = nil
      i.save!
    end
  end
end
