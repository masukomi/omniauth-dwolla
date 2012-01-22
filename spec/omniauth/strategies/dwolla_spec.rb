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

  describe '#info' do
    before :each do
      @access_token = double(:token => 'test_token')
      subject.stub(:access_token) { @access_token }
    end

    it 'get a dwolla user through Dwolla Wrapper' do
      dwolla_user = double( :name => 'Test Name',
                            :latitude => '123',
                            :longitude => '321',
                            :city => 'Sample City',
                            :state => 'TT',
                            :type => 'Personal' )

      dwolla_user.should_receive(:fetch).and_return(dwolla_user)
      ::Dwolla::User.should_receive(:me).with(@access_token.token).and_return(dwolla_user)
      subject.info.should == { 'name'      => 'Test Name',
                               'latitude'  => '123',
                               'longitude' => '321',
                               'city'      => 'Sample City',
                               'state'     => 'TT',
                               'type'      => 'Personal' }
    end
  end

  describe '#uid' do
  end

  describe '#authorize_params' do
    it 'includes default scope for email and offline access' do
      subject.authorize_params.should be_a(Hash)
      subject.authorize_params[:scope].should eq('accountinfofull')
    end
  end
end

