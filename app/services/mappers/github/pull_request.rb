module Mappers
  module Github
    class PullRequest
      class << self
        def call(pull_request_data)
          new(pull_request_data).pull_request
        end
      end

      def pull_request
        @pull_request ||= ::PullRequest.new(
          github_id: github_id,
          title: title,
          repo: repo,
          url: url,
          repo_url: repo_url,
          created_at: created_at,
          state: state,
          draft: draft,
          user: user,
          file_count: file_count,
          additions: additions,
          deletions: deletions,
          comments: comments
        )
      end

      private

      attr_reader :github_id,
                  :issue_comments_url,
                  :review_comments_url,
                  :comments,
                  :number,
                  :title,
                  :repo,
                  :url,
                  :repo_url,
                  :created_at,
                  :state,
                  :draft,
                  :user,
                  :file_count,
                  :additions,
                  :deletions

      def initialize(pull_request_data)
        @github_id = pull_request_data['id']
        @issue_comments_url = pull_request_data.dig('_links', 'comments', 'href')
        @review_comments_url = pull_request_data.dig('_links', 'review_comments', 'href')
        @number = pull_request_data['number']
        @title = pull_request_data['title']
        @repo = pull_request_data.dig('base', 'repo', 'name')
        @url = pull_request_data.dig('_links', 'html', 'href')
        @repo_url = pull_request_data.dig('base', 'repo', 'html_url')
        @created_at = pull_request_data['created_at']
        @state = pull_request_data['state']
        @draft = pull_request_data['draft']
        @user = pull_request_data.dig('user', 'login')
        # initialize_files_data
        # initialize_comments
      end

      def initialize_files_data
        response = ::Github::Api.fetch_pull_request_files(repo: repo, pull_number: number)
        files = response[:result]
        return if files.blank?

        @file_count = files.count
        @additions = files.map { |f| f['additions'] }.sum
        @deletions = files.map { |f| f['deletions'] }.sum
      end

      def initialize_comments
        issue_comments_response = ::Github::Api.fetch_issue_comments(url: issue_comments_url)
        issue_comments = issue_comments_response[:result]

        return if issue_comments_response[:error].present?

        review_comments_response = ::Github::Api.fetch_review_comments(url: review_comments_url)
        review_comments = review_comments_response[:result]

        return if review_comments_response[:error].present?

        @comments = (issue_comments + review_comments).count
      end
    end
  end
end
