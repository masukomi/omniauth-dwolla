require 'omniauth-oauth2'
require 'dwolla'

module OmniAuth
  module Strategies
    class Dwolla < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'accountinfofull'

      option :client_options, {
        :site => 'https://www.dwolla.com',
        :authorize_url => '/oauth/v2/authenticate',
        :token_url => '/oauth/v2/token'
      }

      uid { raw_info.id }

      info do
        prune!({
          'name'      => raw_info.name,
          'latitude'  => raw_info.latitude,
          'longitude' => raw_info.longitude,
          'city'      => raw_info.city,
          'state'     => raw_info.state,
          'type'      => raw_info.type
        })
      end

      def authorize_params
        super.tap do |params|
          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      def raw_info
        @raw_info ||= ::Dwolla::User.me(access_token.token).fetch
      end

      private

        def prune!(hash)
          hash.delete_if do |_, value| 
            prune!(value) if value.is_a?(Hash)
            value.nil? || (value.respond_to?(:empty?) && value.empty?)
          end
        end
     end
   end
end
