module Github
  class OAuth
    ACCESS_TOKEN_URL = "#{ENVied.OAUTH_BASE_URL}/access_token".freeze

    class << self
      def get_token(code)
        new(code).get_token
      end
    end

    def initialize(code)
      @code = code
      @http = init_client
      @headers = { Accept: 'application/json' }
    end

    attr_reader :code, :http, :headers

    def get_token
      params = {
        client_id: ENVied.CLIENT_ID,
        client_secret: ENVied.CLIENT_SECRET,
        code: code
      }

      begin
        response = http.post(ACCESS_TOKEN_URL, params, headers)
        token = response.body['access_token']

        if token.present?
          { token: token }
        else
          message = "GitHub OAuth failed: #{response.body['error_description']}"
          { error: message }
        end
      rescue Faraday::ConnectionFailed => e
        raise "GitHub OAuth failed: #{e.message}"
      end
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
