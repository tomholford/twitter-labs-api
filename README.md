# twitter-labs-api

A basic implementation of a Twitter Labs API client in Ruby. This project uses the v2 endpoints announced [here](https://twittercommunity.com/t/releasing-a-new-version-of-labs-endpoints/134219/3).

## Usage

### Prerequisite
All one needs is a Twitter [bearer token](https://developer.twitter.com/en/docs/basics/authentication/oauth-2-0/bearer-tokens) to get started.

One easy way to get a bearer token is to use [this method](https://www.rubydoc.info/gems/twitter/Twitter/REST/Client#bearer_token%3F-instance_method) from https://github.com/sferik/twitter.

### Example

```ruby
requre `labs_api`

api = LabsAPI.new(bearer_token: 'YOUR-BEARER-TOKEN')

api.get_tweet(id: '1234671272602193920')

>> {"data"=>{"author_id"=>"44196397", "created_at"=>"2020-03-03T02:45:45.000Z", "id"=>"1234671272602193920", "lang"=>"und", "public_metrics"=>{"retweet_count"=>4534, "reply_count"=>1036, "like_count"=>43489, "quote_count"=>224}, "text"=>"✌️ bro https://t.co/nJ7CUyhr2j"}}
```

### Status
Currently, the following endpoints are implemented:

- `LabsAPI#get_tweet` - get a single tweet, by `id`
- `LabsAPI#get_tweets` - get a list of tweets, by `ids`
- `LabsAPI#get_user`, - get a single user, by `id`

## Roadmap

Since this project is initially driven by my own usage of the API, I will focus on implementing and refinining the Tweets, Users, and Metrics endpoints. If this repo gets enough interest, I might implement the other endpoints.

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
