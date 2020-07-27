describe TwitterLabsAPI::Resources::User do
  let(:client) { TwitterLabsAPI::Client.new(bearer_token: 'token') }

  describe '#get_user' do
    let(:endpoint_stub) do
      stub_request(:get, 'https://api.twitter.com/labs/2/users/1?user.fields=id,name,username')
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

    subject { client.get_user(id: '1') }

    it 'queries the /users/:id endpoint' do
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

    context 'api error (e.g., user not found)' do
      let(:response_body) { '{"data":{}, "errors":[{"title":"", "detail":"", "type":""}]}' }

      it 'raises an APIError' do
        expect { subject }.to raise_error(TwitterLabsAPI::APIError)
      end
    end
  end

  describe '#get_users_by_usernames' do
    let(:endpoint_stub) do
      stub_request(:get, 'https://api.twitter.com/labs/2/users/by?usernames=test&user.fields=id,name,username').
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

    subject { client.get_users_by_usernames(usernames: ['test']) }

    it 'queries the /users endpoint' do
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

    context 'api error (e.g., user not found)' do
      let(:response_body) { '{"data":{}, "errors":[{"title":"", "detail":"", "type":""}]}' }

      it 'raises an APIError' do
        expect { subject }.to raise_error(TwitterLabsAPI::APIError)
      end
    end
  end

  describe '#get_users' do
    let(:endpoint_stub) do
      stub_request(:get, 'https://api.twitter.com/labs/2/users?ids=1&user.fields=id,name,username').
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

    subject { client.get_users(ids: ['1']) }

    it 'queries the /users endpoint' do
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

    context 'api error (e.g., user not found)' do
      let(:response_body) { '{"data":{}, "errors":[{"title":"", "detail":"", "type":""}]}' }

      it 'raises an APIError' do
        expect { subject }.to raise_error(TwitterLabsAPI::APIError)
      end
    end
  end
end
