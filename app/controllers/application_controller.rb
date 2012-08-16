class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate

  protected
  def authenticate
    if Rails.env.production?
      authenticate_or_request_with_http_basic do |username, password|
        username == "gast" && password == "test"
      end
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not found')
  end
end
