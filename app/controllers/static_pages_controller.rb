
class StaticPagesController < ApplicationController
  def home
    @page = StaticPage.find_by_name('start')
  end
end
