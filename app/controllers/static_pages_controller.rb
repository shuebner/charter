
class StaticPagesController < ApplicationController
  def show
    @page = StaticPage.find_by_name(params[:slug])
    render 'page'
  end
end
