require 'spec_helper'

describe OmniAuth::Strategies::Dwolla do
  subject do
    OmniAuth::Strategies::Dwolla.new(nil, @options || {})
  end

  it_should_behave_like 'an oauth2 strategy'

  describe '#client' do
    it 'should have the correct dwolla site' do
      subject.client.site.should eq("https://www.dwolla.com")
    end

    it 'should have the correct authorization url' do
      subject.client.options[:authorize_url].should eq("/oauth/v2/authenticate")
    end

    it 'should have the correct token url' do
      subject.client.options[:token_url].should eq('/oauth/v2/token')
    end
  end
end
