require 'omniauth-oauth2'
require 'dwolla'

module OmniAuth
  module Strategies
    class Dwolla < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'send|transactions|balance|request|accountinfofull'

      option :client_options, {
        :site => 'https://www.dwolla.com',
        :authorize_url => '/oauth/v2/authenticate',
        :token_url => '/oauth/v2/token'
      }

      uid { info.id }

      info do
        prune!({
          'name'      => info.name,
          'latitude'  => info.latitude,
          'longitude' => info.longitude,
          'city'      => info.city,
          'state'     => info.state,
          'type'      => info.type
        })
      end

      def authorize_params
        super.tap do |params|
          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      def info
        @info ||= ::Dwolla::User.me(access_token.token)
      end
    end
  end
end
