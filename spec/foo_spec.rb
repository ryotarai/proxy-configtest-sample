require 'spec_helper'

describe server(:proxy) do
  describe http('http://foo.example.com') do
    it 'returns 200' do
      expect(response.status).to eq(200)
    end
  end
end

