class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def not_found
    raise ActionController::RoutingError.new('Not found')
  end
end
