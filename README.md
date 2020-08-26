# twitter-labs-api

[![Labs v2](https://img.shields.io/static/v1?label=Twitter%20API&message=Developer%20Labs%20v2&color=192430&style=flat&logo=Twitter)](https://developer.twitter.com/en/docs/labs/overview/versioning)

A basic implementation of a Twitter Labs API client as a handy Ruby [gem](https://rubygems.org/gems/twitter_labs_api). This project uses the v2 endpoints announced [here](https://twittercommunity.com/t/releasing-a-new-version-of-labs-endpoints/134219/3).

## Usage

### Prerequisite
All one needs is a Twitter [bearer token](https://developer.twitter.com/en/docs/basics/authentication/oauth-2-0/bearer-tokens) to get started. The bearer token is available on the 'Tokens and Keys' page within your app's dashboard on the [Twitter for Developers](https://developer.twitter.com/) site.

Alternatively, one can get a bearer token using [this method](https://www.rubydoc.info/gems/twitter/Twitter/REST/Client#bearer_token%3F-instance_method) from https://github.com/sferik/twitter.

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

By default, the gem requests the 'default' fields for each entity. See the [API Reference](https://developer.twitter.com/en/docs/labs/tweets-and-users/api-reference) for available fields. One can customize the response payload, depending on the requested resource.

For example, to request the URL of a Tweet's embedded media item:
```ruby
requested_fields = { tweet: %w[id username], media: %w[url] }

api.get_tweet(id: my_id, fields: requested_fields)
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

#### Tweets

- `TwitterLabsAPI#get_tweet` ([docs](https://developer.twitter.com/en/docs/labs/tweets-and-users/api-reference/get-tweets-id)) - Retrieve a single Tweet object with an `id`
- `TwitterLabsAPI#get_tweets` ([docs](https://developer.twitter.com/en/docs/labs/tweets-and-users/api-reference/get-tweets)) - Retrieve multiple Tweets with a collection of `ids`
- `TwitterLabsAPI#hide_reply` ([docs](https://developer.twitter.com/en/docs/labs/hide-replies/api-reference/put-hidden)) - Hide a reply by referencing it's `id`; must be in a conversation belonging to the authenticating user
- `TwitterLabsAPI#search` ([docs](https://developer.twitter.com/en/docs/labs/recent-search/api-reference/get-recent-search)) - Returns Tweets from the last 7 days that match a search query.

#### Users

- `TwitterLabsAPI#get_user` ([docs](https://developer.twitter.com/en/docs/labs/tweets-and-users/api-reference/get-users-id)) - Retrieve a single user object with an `id`
- `TwitterLabsAPI#get_users` ([docs](https://developer.twitter.com/en/docs/labs/tweets-and-users/api-reference/get-users)) - Retrieve multiple user objects with a collection of `ids`
- `TwitterLabsAPI#get_users_by_username` ([docs](https://developer.twitter.com/en/docs/labs/tweets-and-users/api-reference/get-users)) - Retrieve multiple user objects with a collection of `usernames`

## Roadmap

Currently focused on implementing support for all v2 endpoints; if there is enough interest, I will add v1 endpoint support as well.

And of course, contributions are welcome :)

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
