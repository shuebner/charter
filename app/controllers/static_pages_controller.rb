
class StaticPagesController < ApplicationController
  def home
    @page = StaticPage.find_by_name('start')
  end

  def area
    @page = StaticPage.find_by_name('area')
  end

  def trips
    @page = StaticPage.find_by_name('trips')
  end

  def imprint
    @page = StaticPage.find_by_name('imprint')
  end
end
