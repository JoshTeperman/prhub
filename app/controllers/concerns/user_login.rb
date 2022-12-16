module UserLogin
  extend ActiveSupport::Concern

  included do
    helper_method :login_user
  end

  private

  def login_user(github_user, access_token:)
    user = User.find_or_create_by(github_id: github_user.id) do |new_user|
      new_user.name = github_user.name
    end

    render json: { error: "Error registering user: #{user.errors.full_messages.to_sentence}" } and return unless user.valid?

    Current.user = user
    cookies.encrypted['user_id'] = user.id
    update_user_access_token(user: user, access_token: access_token)
  end

  def update_user_access_token(user:, access_token:)
    encrypted_access_token = TokenEncryptor.encrypt(access_token)
    return if encrypted_access_token.blank?

    user.update(encrypted_access_token: encrypted_access_token)
  end
end
