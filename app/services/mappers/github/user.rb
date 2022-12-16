module Mappers
  module Github
    class User
      class << self
        def call(user_data)
          new(user_data).github_user
        end
      end

      attr_reader :github_user

      private

      attr_reader :id, :name

      def initialize(user_data)
        @id = user_data['id']
        @name = user_data['name']
        @github_user = initialize_github_user
      end

      def initialize_github_user
        ::GithubUser.new(id: id, name: name)
      end
    end
  end
end
