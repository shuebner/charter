
class StaticPagesController < ApplicationController
  def show
    @page = StaticPage.find_by_name(params[:slug]) || not_found
    render 'page'
  end
end
