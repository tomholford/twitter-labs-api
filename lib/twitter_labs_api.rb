require 'json'
require 'net/http'
require 'uri'
require 'active_support/core_ext/hash/indifferent_access'
require_relative 'twitter_labs_api/client'

# A basic implementation of a Twitter Labs API client.
module TwitterLabsAPI
  class << self
    def new(bearer_token:, debug: false)
      Client.new(bearer_token: bearer_token, debug: debug)
    end
  end
end
