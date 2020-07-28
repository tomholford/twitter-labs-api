module TwitterLabsAPI
  module Resources
    module Tweet
      DEFAULT_TWEET_FIELDS = %w[id author_id created_at lang public_metrics].freeze

      # @param [String] :id the ID of the requested Tweet
      # @param [Array<String>] :tweet_fields (["id", "author_id", "created_at", "lang", "public_metrics"]) the list of fields to retrieve for the given tweet
      # @return Hash an object with requested tweet fields
      def get_tweet(id:, tweet_fields: DEFAULT_TWEET_FIELDS)
        url = "https://api.twitter.com/labs/2/tweets/#{id}"
        params = {
          'tweet.fields' => tweet_fields.join(',')
        }.compact

        make_request(url: url, params: params)
      end

      # @param [Array<String>] :ids the collection of requested Tweet IDs
      # @param [Array<String>] :tweet_fields (["id", "author_id", "created_at", "lang", "public_metrics"]) the list of fields to retrieve for the given tweet
      # @return [Array<Hash>] of tweet objects with the requested tweet fields
      def get_tweets(ids:, tweet_fields: DEFAULT_TWEET_FIELDS)
        url = 'https://api.twitter.com/labs/2/tweets'
        params = {
          'ids' => ids.join(','),
          'tweet.fields' => tweet_fields.join(',')
        }.compact

        make_request(url: url, params: params, is_collection: true)
      end

      # @param [String] :id the ID of the requested Tweet; must belong to a conversation by the authenticated user
      # @return boolean indicating the hidden status of the requested tweet
      def hide_reply(id:)
        url = "https://api.twitter.com/labs/2/tweets/#{id}/hidden"

        make_request(url: url, method: :put)[:hidden]
      end
    end
  end
end
