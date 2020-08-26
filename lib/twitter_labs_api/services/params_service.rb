class ParamsService
  # Convert user-passed fields hash to query params
  # @param [Hash] :fields A hash of requested fields; see API Reference for details
  # @return [Hash] A hash of query params for consumption by API client
  # @example
  #     input: { tweet: %w[id username], media: ['url'] }
  #     output: { 'tweet.fields' => 'id,username', 'media.fields' => 'url }
  def self.from_fields(fields)
    fields.keys.inject({}) do |memo, key|
      memo["#{key}.fields"] = fields[key].join(',')

      memo
    end
  end
end
