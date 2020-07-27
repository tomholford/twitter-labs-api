module TwitterLabsAPI
  module Resources
    module User
      DEFAULT_USER_FIELDS = %w[name username].freeze

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
    end
  end
end
