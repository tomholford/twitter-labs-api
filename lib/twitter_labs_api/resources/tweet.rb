module TwitterLabsAPI
  module Resources
    module Tweet
      DEFAULT_TWEET_FIELDS = %w[id author_id created_at lang public_metrics].freeze
      DEFAULT_FIELDS = { tweet: DEFAULT_TWEET_FIELDS }.freeze

      # Returns a variety of information about a single Tweet specified by the requested ID.
      # @param [String] :id the ID of the requested Tweet
      # @param [Hash] :fields a hash for fields to include in the response payload; 
      #
      #     e.g.: { tweet: %w[id username], media: %w[url] }
      # @return Hash an object with requested tweet fields
      def get_tweet(id:, fields: DEFAULT_FIELDS)
        url = "https://api.twitter.com/labs/2/tweets/#{id}"
        params = ParamsService.from_fields(fields)

        make_request(url: url, params: params)
      end

      # Returns a variety of information about the Tweet specified by the requested ID or list of IDs.
      # @param [Array<String>] :ids the collection of requested Tweet IDs
      # @param [Hash] :fields a hash for fields to include in the response payload; 
      #
      #     e.g.: { tweet: %w[id username], media: %w[url] }
      # @return [Array<Hash>] of tweet objects with the requested tweet fields
      def get_tweets(ids:, fields: DEFAULT_FIELDS)
        url = 'https://api.twitter.com/labs/2/tweets'
        params = ParamsService.from_fields(fields)
        params.merge!({ ids: ids.join(',') })

        make_request(url: url, params: params, is_collection: true)
      end

      # Hides or unhides a reply to a Tweet.
      # @param [String] :id the ID of the requested Tweet; must belong to a conversation by the authenticated user
      # @return boolean indicating the hidden status of the requested tweet
      def hide_reply(id:)
        url = "https://api.twitter.com/labs/2/tweets/#{id}/hidden"

        make_request(url: url, method: :put)[:hidden]
      end

      # The Labs recent search endpoint returns Tweets from the last 7 days that match a search query.
      # @param [String] :query the search query
      # @param [Hash] :fields a hash for fields to include in the response payload; 
      #
      #     e.g.: { tweet: %w[id username], media: %w[url] }
      # @return [Array<Hash>] of tweet objects with the requested tweet fields
      def search(query:, fields: DEFAULT_FIELDS)
        url = 'https://api.twitter.com/labs/2/tweets/search'
        params = ParamsService.from_fields(fields)
        params.merge!({ query: query })

        make_request(url: url, params: params, is_collection: true)
      end
    end
  end
end
