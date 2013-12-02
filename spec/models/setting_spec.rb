require 'spec_helper'

describe Setting do
  let(:setting) { build(:setting) }

  subject { setting }

  it { should respond_to(:key) }
  it { should respond_to(:value) }

  it { should be_valid }

  [:key, :value].each do |s|
    describe "when #{s.to_s}" do
      describe "is empty" do
        before { setting[s] = nil }
        it { should_not be_valid }
      end
    end
  end

  describe "date settings" do
    describe "class methods" do    
      describe "getters" do
        before { create(:setting, key: 'current_period_start_at', value: I18n.l(Date.new(2014, 1, 1))) }
        it "should retrieve the date as Date object" do
          Setting.current_period_start_at.class.should == Date
          # Setting.current_period_end_at.class.should == Date
        end
      end
      describe "setters" do
        describe "if setting already exists" do
          before { create(:setting, key: 'current_period_start_at', value: I18n.l(Date.new(2014, 1, 1))) }
          it "should set the date from a date object" do
            new_date = Date.new(2014, 1, 2)
            Setting.current_period_start_at = new_date
            Setting.current_period_start_at.should == new_date
          end
        end
        describe "if setting does not yet exist" do
          it "should create the setting" do
            expect { Setting.current_period_start_at = Date.new(2014, 1, 1) }.to change(Setting, :count).by(1)
          end
        end
      end
    end
    [:current_period_start_at, :current_period_end_at].each do |key|
      let(:setting) { build(:setting, key: key.to_s) }
      describe "when #{key.to_s} is not a valid date" do        
        ["bla", "31.02.2013"].each do |invalid_date_string|
          before { setting.value = invalid_date_string }
          it { should_not be_valid }
        end
      end
    end
  end

  describe "destruction" do
    before { setting.save }
    it "should not be possible at all" do
      expect { setting.destroy }.not_to change(Setting, :count)
    end
  end

  describe "change of key name" do
    before { setting.save }
    it "should not be possible at all" do
      old_key = setting.key
      setting.key = 'not' + old_key
      setting.save!
      setting.reload
      setting.key.should == old_key
    end
  end
end