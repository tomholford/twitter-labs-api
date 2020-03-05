require 'json'
require 'net/http'
require 'uri'
require 'active_support/core_ext/hash/indifferent_access'

DEFAULT_TWEET_FIELDS = %w[id author_id created_at lang public_metrics].join(',').freeze
DEFAULT_USER_FIELDS = %w[name username].join(',').freeze

class TwitterLabsAPIError < StandardError; end

class TwitterLabsAPI
  attr_accessor :bearer_token, :debug

  def initialize(bearer_token:, debug: false)
    @bearer_token = bearer_token
    @debug = debug
    require 'httplog' if debug
  end

  def get_tweet(id:, tweet_fields: DEFAULT_TWEET_FIELDS)
    url = "https://api.twitter.com/labs/2/tweets/#{id}"
    params = {
      'tweet.fields' => tweet_fields
    }.compact

    make_request(url: url, params: params)
  end

  def get_tweets(ids:, tweet_fields: DEFAULT_TWEET_FIELDS)
    url = 'https://api.twitter.com/labs/2/tweets'
    params = {
      'ids' => ids.join(','),
      'tweet.fields' => tweet_fields
    }.compact

    make_request(url: url, params: params, is_collection: true)
  end

  def get_user(id:, user_fields: DEFAULT_USER_FIELDS)
    url = "https://api.twitter.com/labs/2/users/#{id}"
    params = {
      'user.fields' => user_fields
    }.compact

    make_request(url: url, params: params)
  end

  def get_users(ids:, user_fields: DEFAULT_USER_FIELDS)
    url = 'https://api.twitter.com/labs/2/users'
    params = {
      'ids' => ids.join(','),
      'user.fields' => user_fields
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

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    is_collection ? handle_collection(response) : handle_single(response)
  end

  # TODO: handle non-api errs (e.g., timeouts)
  def handle_single(response)
    return JSON.parse(response.body)['data'].with_indifferent_access if response.is_a?(Net::HTTPSuccess)

    handle_api_error(response)
  end

  def handle_collection(response)
    return JSON.parse(response.body)['data'].map(&:with_indifferent_access) if response.is_a?(Net::HTTPSuccess)

    handle_api_error(response)
  end

  def handle_api_error(response)
    error = JSON.parse(response.body)

    raise TwitterLabsAPIError, "#{error['title']}: #{error['detail']} #{error['type']}"
  end
end
