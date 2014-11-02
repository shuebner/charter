# encoding utf-8
require 'spec_helper'

describe "BlogEntryComments" do
  subject { page }

  # describe "new comment" do

  #   let!(:entry) { create(:blog_entry) }

  #   describe "with invalid parameters" do
  #     describe "for non-existing blog entry" do
  #       let(:nonexisting_entry) { build(:blog_entry) }    
  #       it "should cause a routing error" do
  #         expect do
  #           visit new_blog_entry_comment_path(blogeintrag: nonexisting_entry.slug)
  #         end.to raise_error(ActionController::RoutingError)
  #       end
  #     end

  #     describe "for inactive blog entry" do
  #       let!(:inactive_entry) { create(:blog_entry, active: false) }
  #       it "should cause a routing error" do
  #         expect do
  #           visit new_blog_entry_comment_path(blogeintrag: inactive_entry.slug)
  #         end.to raise_error(ActionController::RoutingError)
  #       end
  #     end
  #   end

    # describe "form" do

    #   describe "site top" do        
    #     let!(:latest_comment) { create(:blog_entry_comment, blog_entry: entry) }
    #     let!(:past_comment) { create(:blog_entry_comment, blog_entry: entry,
    #       created_at: latest_comment.created_at - 1.day) }

    #     before { visit new_blog_entry_comment_path(blogeintrag: entry.slug) }    
        
    #     it "should show the contents of the entry" do
    #       within '#content' do
    #         page.should have_content(entry.heading)
    #         page.should have_content(entry.text)
    #       end
    #     end

    #     it "should show existing comments ascending by created_at" do
    #       within '#content ul.blog-entry-comment-list' do
    #         page.should have_selector('li:nth-child(1)', text: past_comment.author)
    #         page.should have_selector('li:nth-child(2)', text: latest_comment.author)
    #       end
    #     end
        
    #     it "should show author and text of existing comments" do
    #       within '#content ul.blog-entry-comment-list li:nth-child(1)' do
    #         page.should have_content(past_comment.author)
    #         page.should have_content(past_comment.text)
    #       end
    #     end
    #   end

      # before { visit new_blog_entry_comment_path(blogeintrag: entry.slug) }

      # describe "on invalid form submit" do
      #   it "should not generate a comment" do
      #     expect do
      #       click_button "Erstellen"
      #     end.not_to change(BlogEntryComment, :count)
      #   end
      #   it "should redirect to the form" do
      #     click_button "Erstellen"
      #     within '#content' do
      #       page.should have_content("Kommentar erstellen")
      #     end
      #   end
      # end

      # describe "on valid form submit" do
      #   it "should generate a comment" do
      #     expect do
      #       fill_and_submit
      #     end.to change(entry.comments, :count).by(1)
      #   end
      #   it "should show success page with link back to the right entry" do
      #     fill_and_submit
      #     within('#content') { page.should have_content('erfolgreich') }
      #     page.should have_link(entry.category.name, href: blog_category_path(entry.category))
      #   end
      # end
    # end
  # end
end

def fill_and_submit
  fill_in "Autor", with: "Max Mustermann"
  fill_in "Text", with: "Das ist ein kurzer Kommentar"
  click_button "Erstellen"
end