RSpec.describe TwitterLabsAPI do
  it 'has a version number' do
    expect(TwitterLabsAPI::VERSION).not_to be nil
  end

  describe '#new' do
    subject { described_class.new(bearer_token: 'token') }

    it 'instantiates an API client' do
      expect(subject).to be_a(TwitterLabsAPI::Client)
    end
  end
end
