shared_examples_for "activatable" do |activatable_class|
  describe "activation" do
    let(:activatable) { activatable_class.new }
    subject { activatable }
    
    describe "active" do
      it "should be false by default" do      
        activatable.active.should == false
      end
    end
    
    describe "after activation by activate!" do
      before { activatable.activate! }
      it { should be_active }

      describe "followed by deactivation by deactivate!" do
        before { activatable.deactivate! }
        it { should_not be_active }
      end
    end
  end
end