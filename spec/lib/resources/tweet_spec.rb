describe TwitterLabsAPI::Resources::Tweet do
  let(:client) { TwitterLabsAPI::Client.new(bearer_token: 'token') }

  describe '#get_tweet' do
    let(:endpoint_stub) do
      stub_request(:get, 'https://api.twitter.com/labs/2/tweets/1')
        .with(
          query: expected_request_query,
          headers:
            {
              'Authorization' => 'Bearer token',
              'Host' => 'api.twitter.com',
            }
        )
        .to_return(status: response_status, body: response_body)
    end

    let(:expected_request_query) do
      {
        'tweet.fields' => 'id,author_id,created_at,lang,public_metrics'
      }
    end

    let(:response_status) { 200 }
    let(:response_body) { '{"data":{}}' }

    before do
      endpoint_stub
    end

    let(:request_fields) do
      {
        'tweet' => %w[id author_id created_at lang public_metrics]
      }
    end

    subject { client.get_tweet(id: '1', fields: request_fields) }

    it 'queries the /tweets/:id endpoint' do
      subject

      expect(endpoint_stub).to have_been_requested
    end

    it 'returns a hash' do
      expect(subject).to be_a(Hash)
    end

    context 'http error (e.g., too many requests)' do
      let(:response_status) { 429 }

      it 'raises an APIError' do
        expect { subject }.to raise_error(TwitterLabsAPI::APIError)
      end
    end

    context 'api error (e.g., tweet not found)' do
      let(:response_body) { '{"data":{}, "errors":[{"title":"", "detail":"", "type":""}]}' }

      it 'raises an APIError' do
        expect { subject }.to raise_error(TwitterLabsAPI::APIError)
      end
    end

    context 'custom field request' do
      let(:expected_request_query) do
        {
          'tweet.fields' => 'id,author_id,created_at,lang,public_metrics',
          'media.fields' => 'url'
        }
      end

      let(:request_fields) do
        {
          'tweet' => %w[id author_id created_at lang public_metrics],
          'media' => %w[url]
        }
      end

      it 'queries the /tweets/:id endpoint' do
        subject
  
        expect(endpoint_stub).to have_been_requested
      end
    end
  end

  describe '#get_tweets' do
    let(:endpoint_stub) do
      stub_request(:get, 'https://api.twitter.com/labs/2/tweets?ids=1&tweet.fields=id,author_id,created_at,lang,public_metrics')
        .with(
          query: expected_request_query,
          headers: {
            'Authorization' => 'Bearer token',
            'Host' => 'api.twitter.com'
          }
        )
        .to_return(status: response_status, body: response_body)
    end

    let(:expected_request_query) do
      {
        'ids' => '1',
        'tweet.fields' => 'id,author_id,created_at,lang,public_metrics'
      }
    end

    let(:response_status) { 200 }
    let(:response_body) { '{"data":{}}' }

    before do
      endpoint_stub
    end

    subject { client.get_tweets(ids: ['1'], fields: request_fields) }

    let(:request_fields) do
      {
        'tweet' => %w[id author_id created_at lang public_metrics]
      }
    end

    it 'queries the /tweets endpoint' do
      subject

      expect(endpoint_stub).to have_been_requested
    end

    it 'returns an Array' do
      expect(subject).to be_an(Array)
    end

    context 'http error (e.g., too many requests)' do
      let(:response_status) { 429 }

      it 'raises an APIError' do
        expect { subject }.to raise_error(TwitterLabsAPI::APIError)
      end
    end

    context 'api error (e.g., tweet not found)' do
      let(:response_body) { '{"data":{}, "errors":[{"title":"", "detail":"", "type":""}]}' }

      it 'raises an APIError' do
        expect { subject }.to raise_error(TwitterLabsAPI::APIError)
      end
    end

    context 'custom field request' do
      let(:expected_request_query) do
        {
          'tweet.fields' => 'id,author_id,created_at,lang,public_metrics',
          'media.fields' => 'url'
        }
      end

      let(:request_fields) do
        {
          'tweet' => %w[id author_id created_at lang public_metrics],
          'media' => %w[url]
        }
      end

      it 'queries the /tweets/:ids endpoint' do
        subject

        expect(endpoint_stub).to have_been_requested
      end
    end
  end

  describe '#hide_reply' do
    let(:endpoint_stub) do
      stub_request(:put, 'https://api.twitter.com/labs/2/tweets/1/hidden')
        .with(
          headers:
            {
              'Authorization'=>'Bearer token',
              'Host'=>'api.twitter.com',
            }
        )
        .to_return(status: response_status, body: response_body)
    end

    let(:response_status) { 200 }
    let(:response_body) { '{"data":{"hidden":true}}' }

    before do
      endpoint_stub
    end

    subject { client.hide_reply(id: '1') }

    it 'queries the /tweets/:id/hidden endpoint' do
      subject

      expect(endpoint_stub).to have_been_requested
    end

    it 'returns a boolean' do
      expect(subject).to be(true)
    end

    context 'http error (e.g., too many requests)' do
      let(:response_status) { 429 }

      it 'raises an APIError' do
        expect { subject }.to raise_error(TwitterLabsAPI::APIError)
      end
    end

    context 'api error (e.g., tweet not found)' do
      let(:response_body) { '{"data":{}, "errors":[{"title":"", "detail":"", "type":""}]}' }

      it 'raises an APIError' do
        expect { subject }.to raise_error(TwitterLabsAPI::APIError)
      end
    end
  end

  describe '#search' do
    let(:endpoint_stub) do
      stub_request(:get, 'https://api.twitter.com/labs/2/tweets/search')
        .with(
          query: expected_request_query,
          headers:
            {
              'Authorization' => 'Bearer token',
              'Host' => 'api.twitter.com'
            }
        )
        .to_return(status: response_status, body: response_body)
    end

    let(:expected_request_query) do
      {
        'query' => 'test',
        'tweet.fields' => 'id,author_id,created_at,lang,public_metrics'
      }
    end

    let(:response_status) { 200 }
    let(:response_body) { '{"data":{}}' }

    before do
      endpoint_stub
    end

    subject { client.search(query: 'test', fields: request_fields) }

    let(:request_fields) do
      {
        'tweet' => %w[id author_id created_at lang public_metrics]
      }
    end

    it 'queries the /tweets/search endpoint' do
      subject

      expect(endpoint_stub).to have_been_requested
    end

    it 'returns an Array' do
      expect(subject).to be_an(Array)
    end

    context 'http error (e.g., too many requests)' do
      let(:response_status) { 429 }

      it 'raises an APIError' do
        expect { subject }.to raise_error(TwitterLabsAPI::APIError)
      end
    end

    context 'api error (e.g., tweet not found)' do
      let(:response_body) { '{"data":{}, "errors":[{"title":"", "detail":"", "type":""}]}' }

      it 'raises an APIError' do
        expect { subject }.to raise_error(TwitterLabsAPI::APIError)
      end
    end

    context 'custom field request' do
      let(:expected_request_query) do
        {
          'query' => 'test',
          'tweet.fields' => 'id,author_id,created_at,lang,public_metrics',
          'media.fields' => 'url'
        }
      end

      let(:request_fields) do
        {
          'tweet' => %w[id author_id created_at lang public_metrics],
          'media' => %w[url]
        }
      end

      it 'queries the /tweets/search endpoint' do
        subject

        expect(endpoint_stub).to have_been_requested
      end
    end
  end
end
