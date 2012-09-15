
class StaticPagesController < ApplicationController
  def show
    @page = StaticPage.find_by_slug(params[:slug]) || not_found
    render 'page'
  end
end
