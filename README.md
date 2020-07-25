# twitter-labs-api

A basic implementation of a Twitter Labs API client as a handy Ruby [gem](https://rubygems.org/gems/twitter_labs_api). This project uses the v2 endpoints announced [here](https://twittercommunity.com/t/releasing-a-new-version-of-labs-endpoints/134219/3).

## Usage

### Prerequisite
All one needs is a Twitter [bearer token](https://developer.twitter.com/en/docs/basics/authentication/oauth-2-0/bearer-tokens) to get started.

One easy way to get a bearer token is to use [this method](https://www.rubydoc.info/gems/twitter/Twitter/REST/Client#bearer_token%3F-instance_method) from https://github.com/sferik/twitter.

### Setup

```shell
gem install twitter_labs_api
```

### Example

#### Getting a Tweet by ID
```ruby
require `twitter_labs_api`

api = TwitterLabsAPI.new(bearer_token: 'YOUR-BEARER-TOKEN')

api.get_tweet(id: '1234671272602193920')

>> {"data"=>{"author_id"=>"44196397", "created_at"=>"2020-03-03T02:45:45.000Z", "id"=>"1234671272602193920", "lang"=>"und", "public_metrics"=>{"retweet_count"=>4534, "reply_count"=>1036, "like_count"=>43489, "quote_count"=>224}, "text"=>"✌️ bro https://t.co/nJ7CUyhr2j"}}
```

#### Specifying which fields to include in the response

By default, the gem requests the 'default' fields for each entity. See the [API Reference](https://developer.twitter.com/en/docs/labs/tweets-and-users/api-reference) for available fields. One can customize the response payload like so:

```ruby
my_fields = %w[id author_id created_at text]

api.get_tweet(id: '1235508591232090112', tweet_fields: my_fields)

>> {"author_id"=>"229708614", "created_at"=>"2020-03-05T10:12:57.000Z", "id"=>"1235508591232090112", "text"=>"Hot take: coronavirus will not boost remote work in the long run because spur-of-the-moment work-from-home for in-person companies is likely to be a shitshow."}
```

#### API Errors

Sometimes the API will respond with an error, for example, `429 Too Many Requests`. The gem will throw an error with the `Net::HTTP` response as an attribute for proper exception-handling by the consuming app:

```ruby
def my_twitter_request
  api.get_tweet(id: '1235508591232090112', tweet_fields: my_fields)

rescue TwitterLabsAPI::APIError => e
  puts e.msg # 429 Too Many Requests
  puts e.response # <Net::HTTPTooManyRequests 429 Too Many Requests readbody=true>
  # do something with the Net::HTTP response...
end
```

### Status
Currently, the following endpoints are implemented:

- `TwitterLabsAPI#get_tweet` - Retrieve a single Tweet object with an `id`
- `TwitterLabsAPI#get_tweets` - Retrieve multiple Tweets with a collection of `ids`
- `TwitterLabsAPI#get_user` - Retrieve a single user object with an `id`
- `TwitterLabsAPI#get_users` - Retrieve multiple user objects with a collection of `ids`

## Roadmap

Since this project is initially driven by my own usage of the API, I will focus on implementing and refining the Tweets, Users, and Metrics endpoints. If this repo gets enough interest, I might implement the other endpoints and create a proper `.gemspec`. And of course, contributions are welcome :)

## Dependencies

This lib uses Ruby's built-in `URI` and `net/http` libs to communicate with Twitter's Labs API.

For ease of manipulating responses, this lib depends on `Hash::WithIndifferentAccess` from the Rails `activesupport` project ([docs](https://api.rubyonrails.org/classes/ActiveSupport/HashWithIndifferentAccess.html)).

Thus, one can access the data from a response like so:
```ruby
response = api.get_tweet(id: '1234671272602193920')

puts response[:data][:public_metrics][:like_count]
>> 43489

puts response['data']['public_metrics']['like_count']
>> 43489
```
