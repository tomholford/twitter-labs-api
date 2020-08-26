describe ParamsService do
  describe '#from_fields' do
    subject { described_class.from_fields(fields) }
    let(:fields) do
      {
        tweet: %w[id username],
        media: %w[url]
      }
    end

    it 'converts a hash of fields to query params' do
      expect(subject).to eq({ 'tweet.fields' => 'id,username', 'media.fields' => 'url' })
    end
  end
end
