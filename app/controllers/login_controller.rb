class LoginController < ApplicationController
  include UserLogin

  def show
    code = params[:code]
    result = Github::OAuth.get_token(code)
    access_token = result[:token]

    render json: { error: result[:error] } and return if access_token.blank?

    user_response = Github::Api.fetch_authenticated_user(access_token: access_token)
    github_user = ::Mappers::Github::User.call(user_response[:result])

    render json: { error: user_response[:error] } and return if github_user.blank?
    render json: { error: github_user.errors.full_messages.to_sentence } and return unless github_user.valid?

    login_user(github_user, access_token: access_token)

    redirect_to dashboard_path
  end

  def destroy
    cookies.delete('user_id')
    redirect_to new_auth_path
  end
end
