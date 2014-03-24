class BlogCategoriesController < ApplicationController
  def index
    latest_category = BlogCategory.latest
    if latest_category
      redirect_to blog_category_path(latest_category)
    end
  end

  def show
    @current_category = BlogCategory.find_by_slug(params[:id]) || not_found
    @current_entries = @current_category.blog_entries.active.order('blog_entries.updated_at DESC')
      .includes(:blog_entry_comments).order('blog_entry_comments.created_at DESC')
    @other_categories = BlogCategory.others(@current_category).by_time
  end
end