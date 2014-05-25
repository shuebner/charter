class BlogEntryCommentsController < ApplicationController
  def new
    @entry = BlogEntry.active.includes(:blog_entry_comments)
      .order('blog_entry_comments.created_at ASC')
      .find_by_slug(params[:blogeintrag]) || not_found
    @new_comment = @entry.comments.build
  end

  def create
    @new_comment = BlogEntryComment.new(params[:blog_entry_comment])
    if @new_comment.save
      @category = BlogEntry.find_by_id(params[:blog_entry_comment][:blog_entry_id]).category
      render 'create'
    else
      @entry = BlogEntry.active.includes(:blog_entry_comments)
        .order('blog_entry_comments.created_at ASC')
        .find_by_id(params[:blog_entry_comment][:blog_entry_id]) || not_found
      render 'new'
    end
  end
end