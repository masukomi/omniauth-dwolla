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

  describe 'getting info' do
    before do
      @access_token = double(:token => 'test_token')
      @dwolla_user  = double( :id => '12345',
                              :name => 'Test Name',
                              :latitude => '123',
                              :longitude => '321',
                              :city => 'Sample City',
                              :state => 'TT',
                              :type => 'Personal' )

      subject.stub(:access_token) { @access_token }

      @dwolla_user.should_receive(:fetch).and_return(@dwolla_user)
      ::Dwolla::User.should_receive(:me).with(@access_token.token).and_return(@dwolla_user)
    end

    it 'set the correct info based on user' do
      subject.info.should == { 'name'      => 'Test Name',
                               'latitude'  => '123',
                               'longitude' => '321',
                               'city'      => 'Sample City',
                               'state'     => 'TT',
                               'type'      => 'Personal' }
    end

    it 'set the correct uid based on user' do
      subject.uid.should == '12345'
    end
  end

  describe '#authorize_params' do
    it 'includes default scope for email and offline access' do
      subject.authorize_params.should be_a(Hash)
      subject.authorize_params[:scope].should eq('accountinfofull')
    end
  end
end

