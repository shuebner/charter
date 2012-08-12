
class StaticPagesController < ApplicationController
  def home
    fetch 'start'
  end

  def area
    fetch 'revier'
  end

  def trips
    fetch 'toerns'
  end

  def imprint
    fetch 'impressum'
  end

  private
  def fetch(page)
    @page = StaticPage.find_by_name(page)
    render 'page'
  end
end
