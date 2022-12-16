module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate!
  end

  private

  def authenticate!
    authenticated_user = User.find_by(id: cookies.encrypted[:user_id])

    if authenticated_user.present? && authenticated_user.encrypted_access_token.present?
      Current.user = authenticated_user
    else
      redirect_to new_auth_path
    end
  end
end
