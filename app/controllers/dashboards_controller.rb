class DashboardsController < MainController
  def show
    pull_requests_response = Github::Api.fetch_all_pull_requests
    @pull_requests = ::Mappers::Github::PullRequests.call(pull_requests_response[:result])
    @user_name = Current.user.name

    render json: { error: @pull_requests_response[:error] } if @pull_requests.nil?
  end
end
