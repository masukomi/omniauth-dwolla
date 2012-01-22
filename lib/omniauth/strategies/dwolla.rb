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

      uid { user.id }

      info do
        prune!({
          'name'      => user.name,
          'latitude'  => user.latitude,
          'longitude' => user.longitude,
          'city'      => user.city,
          'state'     => user.state,
          'type'      => user.type
        })
      end

      def authorize_params
        super.tap do |params|
          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      private
        def user
          @user ||= ::Dwolla::User.me(access_token.token).fetch
        end

        def prune!(hash)
          hash.delete_if do |_, value| 
            prune!(value) if value.is_a?(Hash)
            value.nil? || (value.respond_to?(:empty?) && value.empty?)
          end
        end
     end
   end
end
