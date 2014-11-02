# encoding utf-8
require 'spec_helper'

describe "Blog" do

  subject { page }

  describe "index" do
    before { visit blog_categories_path }
    describe "if there are no categories" do
      it "should show some text saying that there are no categories yet" do
        page.should have_selector('#content', text: 'kein')
      end
    end

    describe "if there are categories" do
      let!(:latest_category) { create(:blog_category) }
      let!(:past_category) { create(:blog_category,
        updated_at: latest_category.updated_at - 1.month) }
      
      it "should redirect to the show page of the latest category" do
        # todo
      end
    end
  end

  describe "show" do
    describe "when category does not exist" do
      it "should cause routing error" do
        expect do
          visit "#{blog_categories_path}/gibtsnicht"
        end.to raise_error(ActionController::RoutingError)
      end
    end

    describe "when category does exist" do
      let!(:current_category) { create(:blog_category) }

      describe "without entries" do
        before { visit blog_category_path(current_category) }
        it "should show some text saying that there are no entries yet" do
          page.should have_selector('#content', text: 'vorhanden' )
        end
      end

      describe "with entries" do
        let!(:secondlatest_entry) { create(:blog_entry, blog_category: current_category) }
        let!(:latest_entry) { create(:blog_entry, blog_category: current_category,
          updated_at: secondlatest_entry.updated_at + 1.day) }
        let!(:latest_entry_image) { create(:blog_entry_image, attachable: latest_entry) }

        let!(:past_comment) { create(:blog_entry_comment, author: "past author",
          blog_entry: latest_entry) }
        let!(:latest_comment) { create(:blog_entry_comment, author: "latest author",
          blog_entry: latest_entry, created_at: past_comment.created_at + 1.day) }

        let!(:deactivated_entry) { create(:blog_entry, blog_category: current_category,
          active: false) }
        
        let!(:other_recent_category) { create(:blog_category) }
        let!(:other_recent_entry) { create(:blog_entry, blog_category: other_recent_category) }
        
        let!(:other_old_category) { create(:blog_category, 
          updated_at: other_recent_category.updated_at - 1.year) }
        let!(:other_old_entry) { create(:blog_entry, blog_category: other_old_category) }
        
        before { visit blog_category_path(current_category) }

        it "should show current category and its active entries descending by updated_at" do
          within '#content' do
            page.should have_selector('h2', text: current_category.name)
            within 'ul.blog-entry-list' do
              page.should have_selector('li:nth-child(1)', text: latest_entry.heading)
              page.should have_selector('li:nth-child(2)', text: secondlatest_entry.heading)
            end
          end
        end

        it "should show heading, text, dates and images and alt texts for entries" do
          within '#content ul.blog-entry-list li:nth-child(1)' do
            page.should have_content(latest_entry.heading)
            page.should have_content(latest_entry.text)
            page.should have_content(I18n.l(latest_entry.created_at))
            page.should have_content(I18n.l(latest_entry.updated_at))
            page.should have_selector('img', src: latest_entry_image.thumb('300x300').url,
              alt: latest_entry_image.attachment_title)
          end
        end

        it "should not show deactivated entries of the current category" do
          page.should_not have_selector('#content li', text: deactivated_entry.heading)
        end

        it "should show comments for the right entry descending by created_at" do
          within '#content ul.blog-entry-list li:nth-child(1) ul.blog-entry-comment-list' do
            page.should have_selector('li:nth-child(1)', text: latest_comment.author)
            page.should have_selector('li:nth-child(2)', text: past_comment.author)
          end
        end

        it "should show comments to every shown entry with author, text and created_at descending by created_at" do
          within '#content ul.blog-entry-comment-list li:nth-child(1)' do
            page.should have_content(latest_comment.author)
            page.should have_content(latest_comment.text)
            page.should have_content(I18n.l(latest_comment.created_at))
          end
        end

        it "should show a message that there are no comments if there are none" do
          within '#content ul.blog-entry-list li:nth-child(2) div.blog-entry-comments' do
            page.should have_content("noch keine")
          end
        end

        # describe "a new comment link" do
        #   it "should exist" do
        #     within 'ul.blog-entry-list li:nth-child(1)' do
        #       page.should have_link("neuen Kommentar")
        #     end
        #   end
        #   it "should lead to the new comment page for the right blog entry" do            
        #     within 'ul.blog-entry-list li:nth-child(1)' do
        #       click_link "neuen Kommentar erstellen"
        #     end
        #     page.should have_selector('#content', text: latest_entry.heading)
        #   end
        # end
        
        it "should not show entries of other categories" do
          within '#content' do
            [other_recent_entry, other_old_entry].each do |e|
              page.should_not have_content(e.heading)
            end
          end
        end
        
        it "should show links to other categories from new to old" do
          within '#content ul.blog-category-list' do
            page.should have_selector('li:first-child a', 
              text: other_recent_category.name, href: blog_category_path(other_recent_category))
            page.should have_selector('li:last-child a',
              text: other_old_category.name, href: blog_category_path(other_old_category))
            page.should_not have_selector('li', text: current_category.name)
          end
        end
      end
    end
  end
end