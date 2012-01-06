require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Dwolla < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://www.dwolla.com',
        :authorize_url => '/oauth/v2/authenticate',
        :token_url => '/oauth/v2/token'
      }
    end
  end
end
