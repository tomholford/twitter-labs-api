describe TwitterLabsAPI::Resources::Tweet do
  let(:client) { TwitterLabsAPI::Client.new(bearer_token: 'token') }

  describe '#get_tweet' do
    let(:endpoint_stub) do
      stub_request(:get, 'https://api.twitter.com/labs/2/tweets/1?tweet.fields=id,author_id,created_at,lang,public_metrics')
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
    let(:response_body) { '{"data":{}}' }

    before do
      endpoint_stub
    end

    subject { client.get_tweet(id: '1') }

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
  end

  describe '#get_tweets' do
    let(:endpoint_stub) do
      stub_request(:get, 'https://api.twitter.com/labs/2/tweets?ids=1&tweet.fields=id,author_id,created_at,lang,public_metrics').
      with(
        headers: {
        'Authorization'=>'Bearer token',
        'Host'=>'api.twitter.com',
        })
        .to_return(status: response_status, body: response_body)
      end

    let(:response_status) { 200 }
    let(:response_body) { '{"data":{}}' }

    before do
      endpoint_stub
    end

    subject { client.get_tweets(ids: ['1']) }

    it 'queries the /tweets endpoint' do
      subject

      expect(endpoint_stub).to have_been_requested
    end

    it 'returns a hash' do
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
  end
end
