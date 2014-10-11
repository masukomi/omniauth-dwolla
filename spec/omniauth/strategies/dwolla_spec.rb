require 'spec_helper'

describe OmniAuth::Strategies::Dwolla do
  subject do
    OmniAuth::Strategies::Dwolla.new(nil, @options || {})
  end

  it_should_behave_like 'an oauth2 strategy'

  describe '#client' do
    it 'should have the correct dwolla site' do
      expect(subject.client.site).to eq("https://www.dwolla.com")
    end

    it 'should have the correct authorization url' do
      expect(subject.client.options[:authorize_url]).to eq("/oauth/v2/authenticate")
    end

    it 'should have the correct token url' do
      expect(subject.client.options[:token_url]).to eq('/oauth/v2/token')
    end

    #TODO find a way to set :provider_ignores_state to true by default
    # and add a test for it. -masukomi
  end

  describe 'getting info' do
    before do
      @access_token = double(:token => 'test_token')
      @dwolla_user  = {       'Id' => '12345',
                              'Name' => 'Test Name',
                              'Latitude' => '123',
                              'Longitude' => '321',
                              'City' => 'Sample City',
                              'State' => 'TT',
                              'Type' => 'Personal' }

      subject.stub(:access_token) { @access_token }
    end

    context 'when successful' do
      before do
        ::Dwolla::Users.should_receive(:me).with(@access_token.token).and_return(@dwolla_user)
      end

      it 'sets the correct info based on user' do
        # note that the keys are all lowercase 
        # unlike the response that came back from Dwolla
        expect(subject.info).to eq({ 'name'      => 'Test Name',
                                     'latitude'  => '123',
                                     'longitude' => '321',
                                     'city'      => 'Sample City',
                                     'state'     => 'TT',
                                     'type'      => 'Personal' })
      end

      it 'sets the correct uid based on user' do
        subject.uid.should == '12345'
      end
    end

    context 'when a Dwolla::AuthenticationError is raised' do
      let(:auth_error) { ::Dwolla::AuthenticationError.new('Dwolla Error Message') }

      before do
        ::Dwolla::Users.should_receive(:me).with(@access_token.token).and_raise(auth_error)
      end

      it 're-raises the appropriate OAuth error' do
        expect {
          subject.uid
        }.to raise_error(OmniAuth::Strategies::OAuth2::CallbackError)
      end

      it 'passes along the original exception' do
        exception = nil

        begin
          subject.uid
        rescue OmniAuth::Strategies::OAuth2::CallbackError => e
          exception = e
          exception.error.should eq(auth_error)
          exception.error_reason.should eq(auth_error.message)
        end

        exception.should be
      end
    end
  end

  describe '#authorize_params' do
    it 'includes default scope for email and offline access' do
      subject.authorize_params.should be_a(Hash)
      subject.authorize_params[:scope].should eq('accountinfofull')
    end
  end
end

