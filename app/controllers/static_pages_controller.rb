
class StaticPagesController < ApplicationController
  def home
    @page = StaticPage.find_by_name('start')
    render 'page'
  end

  def area
    @page = StaticPage.find_by_name('revier')
    render 'page'
  end

  def trips
    @page = StaticPage.find_by_name('toerns')
    render 'page'
  end

  def imprint
    @page = StaticPage.find_by_name('impressum')
    render 'page'
  end
end
