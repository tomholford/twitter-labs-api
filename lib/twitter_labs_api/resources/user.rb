module TwitterLabsAPI
  module Resources
    module User
      DEFAULT_USER_FIELDS = %w[id name username].freeze
      DEFAULT_FIELDS = { user: DEFAULT_USER_FIELDS }.freeze

      # Returns a variety of information about a single more user specified by the requested ID.
      # @param [String] :id the ID of the requested User
      # @param [Hash] :fields  a hash for fields to include in the response payload; 
      #
      #  e.g.: { user: %w[id name username] }
      # @return Hash an object with requested user fields
      def get_user(id:, fields: DEFAULT_FIELDS)
        url = "https://api.twitter.com/labs/2/users/#{id}"
        params = ParamsService.from_fields(fields)

        make_request(url: url, params: params)
      end

      # Returns a variety of information about one or more Users specified by the requested IDs.
      # @param [Array<String>] :ids the collection of requested User IDs
      # @param [Hash] :fields  a hash for fields to include in the response payload; 
      #
      #  e.g.: { user: %w[id name username] }
      # @return [Array<Hash>] of user objects with the requested user fields
      def get_users(ids:, fields: DEFAULT_FIELDS)
        url = 'https://api.twitter.com/labs/2/users'
        params = ParamsService.from_fields(fields)
        params.merge!({ ids: ids.join(',') })

        make_request(url: url, params: params, is_collection: true)
      end

      # Returns a variety of information about one or more Users specified by the requested usernames.
      # @param [Array<String>] :usernames the collection of requested Usernames
      # @param [Hash] :fields  a hash for fields to include in the response payload; 
      #
      #  e.g.: { user: %w[id name username] }
      # @return [Array<Hash>] of user objects with the requested user fields
      def get_users_by_usernames(usernames:, fields: DEFAULT_FIELDS)
        url = 'https://api.twitter.com/labs/2/users/by'
        params = ParamsService.from_fields(fields)
        params.merge!({ usernames: usernames.join(',') })

        make_request(url: url, params: params, is_collection: true)
      end
    end
  end
end
