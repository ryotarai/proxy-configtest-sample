require 'spec_helper'

describe server(:proxy) do
  describe http('http://foo.example.com') do
    it 'returns "Foo"' do
      expect(response.body).to eq('Foo')
    end
  end
end

