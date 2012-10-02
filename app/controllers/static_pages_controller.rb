
class StaticPagesController < ApplicationController
  def show
    @page = StaticPage.find(params[:id]) || not_found
  end
end
