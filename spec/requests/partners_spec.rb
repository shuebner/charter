describe "Partners" do

  subject { page }

  describe "index page" do
    let!(:partner2) { create(:partner, order: 2) }
    let!(:partner1) { create(:partner, order: 1) }
    before { visit partners_path }

    it "should show all partners in the right order" do
      within "ul.partner-list" do
        page.should have_selector("li:nth-child(1)", text: partner1.name)
        page.should have_selector("li:nth-child(2)", text: partner2.name)
      end
    end
  end
end