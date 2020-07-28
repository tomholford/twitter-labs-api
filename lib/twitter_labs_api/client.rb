require_relative 'version'
require_relative 'api_error'
require_relative 'resources/tweet'
require_relative 'resources/user'

module TwitterLabsAPI
  class Client
    include Resources::Tweet
    include Resources::User

    attr_accessor :bearer_token, :debug, :api_response, :parsed_response

    def initialize(bearer_token:, debug: false)
      @bearer_token = bearer_token
      @debug = debug
      require 'httplog' if debug
    end

    private

    def make_request(url:, params: {}, is_collection: false, method: :get)
      uri = URI.parse(url)
      uri.query = URI.encode_www_form(params)
      request = http_adapter(method).new(uri)
      request['Authorization'] = "Bearer #{bearer_token}"
      request['User-Agent'] = "twitter_labs_api gem #{TwitterLabsAPI::VERSION}"
      req_options = { use_ssl: uri.scheme == 'https' }

      self.api_response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
  
      raise_http_error unless api_response.is_a?(Net::HTTPSuccess)
  
      self.parsed_response = JSON.parse(api_response.body)
  
      handle_api_error if error_response?
  
      is_collection ? handle_collection : handle_single
    end

    def http_adapter(method)
      case method
      when :put
        Net::HTTP::Put
      else
        Net::HTTP::Get
      end
    end

    def error_response?
      parsed_response.key?('errors')
    end
  
    def handle_single
      parsed_response['data'].with_indifferent_access
    end
  
    def handle_collection
      parsed_response['data'].map(&:with_indifferent_access)
    end
  
    def raise_http_error
      raise(APIError.new("#{api_response.code} #{api_response.msg}", api_response))
    end
  
    def handle_api_error
      error = parsed_response['errors'].first
  
      raise APIError.new("#{error['title']}: #{error['detail']} #{error['type']}", api_response)
    end
  end
end
