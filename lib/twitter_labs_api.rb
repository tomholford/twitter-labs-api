require 'json'
require 'net/http'
require 'uri'
require 'active_support/core_ext/hash/indifferent_access'

DEFAULT_TWEET_FIELDS = %w[id author_id created_at lang public_metrics].freeze
DEFAULT_USER_FIELDS = %w[name username].freeze

class TwitterLabsAPIError < StandardError; end

# A basic implementation of a Twitter Labs API client.
class TwitterLabsAPI
  attr_accessor :bearer_token, :debug, :api_response, :parsed_response

  def initialize(bearer_token:, debug: false)
    @bearer_token = bearer_token
    @debug = debug
    require 'httplog' if debug
  end

  # @param [String] :id the ID of the requested Tweet
  # @param [Array<String>] :tweet_fields (["id", "author_id", "created_at", "lang", "public_metrics"]) the list of fields to retrieve for the given tweet
  def get_tweet(id:, tweet_fields: DEFAULT_TWEET_FIELDS)
    url = "https://api.twitter.com/labs/2/tweets/#{id}"
    params = {
      'tweet.fields' => tweet_fields.join(',')
    }.compact

    make_request(url: url, params: params)
  end

  # @param [Array<String>] :ids the collection of requested Tweet IDs
  # @param [Array<String>] :tweet_fields (["id", "author_id", "created_at", "lang", "public_metrics"]) the list of fields to retrieve for the given tweet
  def get_tweets(ids:, tweet_fields: DEFAULT_TWEET_FIELDS)
    url = 'https://api.twitter.com/labs/2/tweets'
    params = {
      'ids' => ids.join(','),
      'tweet.fields' => tweet_fields.join(',')
    }.compact

    make_request(url: url, params: params, is_collection: true)
  end

  # @param [String] :id the ID of the requested User
  # @param [Array<String>] :user_fields (["name", "username"]) the list of fields to retrieve for the given User
  def get_user(id:, user_fields: DEFAULT_USER_FIELDS)
    url = "https://api.twitter.com/labs/2/users/#{id}"
    params = {
      'user.fields' => user_fields.join(',')
    }.compact

    make_request(url: url, params: params)
  end

  # @param [Array<String>] :ids the collection of requested User IDs
  # @param [Array<String>] :user_fields (["name", "username"]) the list of fields to retrieve for the given User
  def get_users(ids:, user_fields: DEFAULT_USER_FIELDS)
    url = 'https://api.twitter.com/labs/2/users'
    params = {
      'ids' => ids.join(','),
      'user.fields' => user_fields.join(',')
    }.compact

    make_request(url: url, params: params, is_collection: true)
  end

  private

  def make_request(url:, params: {}, is_collection: false)
    uri = URI.parse(url)
    uri.query = URI.encode_www_form(params)
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{bearer_token}"
    req_options = { use_ssl: uri.scheme == 'https' }

    self.api_response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    raise TwitterLabsAPIError("#{api_response.code} #{api_response.msg}") unless api_response.is_a?(Net::HTTPSuccess)

    self.parsed_response = JSON.parse(api_response.body)

    handle_api_error if error_response?

    is_collection ? handle_collection : handle_single
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

  def handle_api_error
    error = parsed_response['errors'].first

    raise TwitterLabsAPIError, "#{error['title']}: #{error['detail']} #{error['type']}"
  end
end
