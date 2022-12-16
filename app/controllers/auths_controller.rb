class AuthsController < ApplicationController
  NEW_OAUTH_URL = "#{ENVied.OAUTH_BASE_URL}/authorize?client_id=#{ENVied.CLIENT_ID}".freeze

  def new
    @auth_url = NEW_OAUTH_URL
  end
end
