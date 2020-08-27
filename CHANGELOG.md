# 0.7.1 - 28 August 2020

- Fix: add missing require statement

# 0.7.0 - 28 August 2020

- Refactor interface for requesting custom response fields

## Breaking Change

Heads up, the argument to request fields was previously called `tweet_fields`; it is now called `fields`. 

```ruby
api.get_tweet(id: '123455683780', fields: requested_fields)
```

The `fields` parameter now supports multiple different data types (instead of just Tweet attributes). So for example, to request the URL of an embedded media item:

```ruby
requested_fields = { tweet: %w[id username], media: %w[url] }

api.get_tweet(id: my_id, fields: requested_fields)
```

# 0.6.0 - 28 July 2020

- Fix: broken dependency

# 0.5.2 - 28 July 2020

- Add `search`
- Finish `rdoc` coverage

# 0.5.1 - 28 July 2020

- Add `User-Agent` request header
- Add `hide_reply`

# 0.5.0 - 27 July 2020

- Refactor structure to prepare for adding additional API endpoints
- Add `get_users_by_username`
- Add some test coverage


# 0.4.0 - 24 July 2020

- Better exception-handling: when API returns an error, a `TwitterLabsAPI::APIError` is thrown. It has the `Net::HTTP` response as an attribute so that the error can be handled properly. See the README for an example.


# 0.3.0 - 28 April 2020

- Fix: namespace of error class

# 0.2.0 - 5 March 2020

- Fix: Handle 'successful' API errors (i.e., HTTP 200 response, but API error such as User Not Found)
- Documented expansion fields
- Documented methods

# 0.1.0 - 5 March 2020

Initial gem commit