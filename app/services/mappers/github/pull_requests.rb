module Mappers
  module Github
    class PullRequests
      class << self
        def call(pull_requests_data)
          new(pull_requests_data).pull_requests
        end
      end

      attr_reader :pull_requests

      private

      def initialize(pull_requests_data)
        @pull_requests = initialize_pull_requests(pull_requests_data).compact
      end

      def initialize_pull_requests(pull_requests_data)
        result = pull_requests_data.map do |pull_request_data|
          next if pull_request_data.dig('user', 'login') == 'dependabot[bot]'

          ::Mappers::Github::PullRequest.call(pull_request_data)
        end

        result.compact
      end
    end
  end
end
