module Github
  class Api
    AUTHENTICATED_USER_PATH = "#{ENVied.GITHUB_API_BASE_URL}/user".freeze
    ALL_REPOSITORIES = [
      # TODO: strategy for picking repositories
    ].freeze

    class << self
      def fetch_authenticated_user(access_token:)
        response = new(access_token: access_token).authenticated_user

        if response.success?
          { result: response.body }
        else
          message = "Error fetching authenticated user: #{response.body['message']}"
          { error: message, status: response.status }
        end
      end

      def fetch_all_pull_requests
        responses = new.all_pull_requests

        if responses.all?(&:success?)
          { result: responses.flat_map(&:body) }
        else
          failed_responses = responses.reject(&:success?)
          error_messages = failed_responses.map { |response| "Request URL(#{response.env.url}): #{response.body['message']}" }
          message = "Error fetching pull_requests for #{error_messages.join(', ')}"
          { error: message, status: failed_responses.first.status }
        end
      end

      def fetch_pull_request_files(repo:, pull_number:)
        response = new.pull_request_files(repo: repo, pull_number: pull_number)
        if response.success?
          { result: response.body }
        else
          message = "Error fetching pull_request files: #{response.body['message']}"
          { error: message, status: response.status }
        end
      end

      def fetch_issue_comments(url:)
        response = new.issue_comments(url: url)

        if response.success?
          { result: response.body }
        else
          message = "Error fetching issue_comments: #{response.body['message']}"
          { error: message, status: response.status }
        end
      end

      def fetch_review_comments(url:)
        response = new.review_comments(url: url)

        if response.success?
          { result: response.body }
        else
          message = "Error fetching review comments: #{response.body['message']}"
          { error: message, status: response.status }
        end
      end
    end

    attr_reader :http, :headers

    def initialize(access_token: TokenEncryptor.decrypt(Current.user.encrypted_access_token))
      @http = init_client
      @headers = {
        'Accept' => 'application/json',
        'Authorization' => "token #{access_token}"
      }
    end

    def authenticated_user
      http.get(AUTHENTICATED_USER_PATH, {}, headers)
    rescue Faraday::ConnectionFailed => e
      raise "GitHub API error: #{e.message}"
    end

    def all_pull_requests
      params = { state: 'open', sort: 'created', direction: 'desc' }

      ALL_REPOSITORIES.map do |repository_name|
        url = "#{ENVied.GITHUB_API_BASE_URL}/repos/JoshTeperman/#{repository_name}/pulls"
        http.get(url, params, headers)
      rescue Faraday::ConnectionFailed => e
        raise "GitHub API error: #{e.message}"
      end
    end

    def pull_request_files(repo:, pull_number:)
      url = "#{ENVied.GITHUB_API_BASE_URL}/repos/JoshTeperman/#{repo}/pulls/#{pull_number}/files"
      http.get(url, {}, headers)
    rescue Faraday::ConnectionFailed => e
      raise "GitHub API error: #{e.message}"
    end

    def issue_comments(url:)
      http.get(url, {}, headers)
    rescue Faraday::ConnectionFailed => e
      raise "GitHub API error: #{e.message}"
    end

    def review_comments(url:)
      http.get(url, {}, headers)
    rescue Faraday::ConnectionFailed => e
      raise "GitHub API error: #{e.message}"
    end

    private

    def init_client
      Faraday.new do |conn|
        conn.request :json
        conn.response :json
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
