require 'spec_helper'

describe server(:proxy) do
  describe http('http://foo.example.com') do
    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'proxies to app-001' do
      expect(response.body).to be_json_including({
        'X_MOCK_HOST' => 'app-001',
      })
    end
  end

  describe http('http://foo.example.com/isucon') do
    it 'returns Cache-Control header' do
      expect(response.headers['Cache-Control']).to eq('max-age=86400')
    end
  end
end

