module TwitterLabsAPI
  module Resources
    module User
      DEFAULT_USER_FIELDS = %w[id name username].freeze

      # Returns a variety of information about a single more user specified by the requested ID.
      # @param [String] :id the ID of the requested User
      # @param [Array<String>] :user_fields (["name", "username"]) the list of fields to retrieve for the given User
      # @return Hash an object with requested user fields
      def get_user(id:, user_fields: DEFAULT_USER_FIELDS)
        url = "https://api.twitter.com/labs/2/users/#{id}"
        params = {
          'user.fields' => user_fields.join(',')
        }.compact

        make_request(url: url, params: params)
      end

      # Returns a variety of information about one or more Users specified by the requested IDs.
      # @param [Array<String>] :ids the collection of requested User IDs
      # @param [Array<String>] :user_fields (["name", "username"]) the list of fields to retrieve for the given User
      # @return [Array<Hash>] of user objects with the requested user fields
      def get_users(ids:, user_fields: DEFAULT_USER_FIELDS)
        url = 'https://api.twitter.com/labs/2/users'
        params = {
          'ids' => ids.join(','),
          'user.fields' => user_fields.join(',')
        }.compact

        make_request(url: url, params: params, is_collection: true)
      end

      # Returns a variety of information about one or more Users specified by the requested usernames.
      # @param [Array<String>] :usernames the collection of requested Usernames
      # @param [Array<String>] :user_fields (["name", "username"]) the list of fields to retrieve for the given User
      # @return [Array<Hash>] of user objects with the requested user fields
      def get_users_by_usernames(usernames:, user_fields: DEFAULT_USER_FIELDS)
        url = 'https://api.twitter.com/labs/2/users/by'
        params = {
          'usernames' => usernames.join(','),
          'user.fields' => user_fields.join(',')
        }.compact

        make_request(url: url, params: params, is_collection: true)
      end
    end
  end
end
