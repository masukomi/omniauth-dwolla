require 'omniauth-oauth2'
require 'dwolla'

module OmniAuth
  module Strategies
    class Dwolla < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'accountinfofull'
      option :name, 'dwolla'
      option :client_options, {
        :site => 'https://www.dwolla.com',
        :authorize_url => '/oauth/v2/authenticate',
        :token_url => '/oauth/v2/token'
      }
      #option :provider_ignores_state, true
      # setting that has NO effect. 
      # If anyone can figure a way to make it work
      # PLEASE issue a pull request. -masukomi

      uid { user['Id'] }

      info do
        prune!({
         'name'      => user['Name'],
         'latitude'  => user['Latitude'],
         'longitude' => user['Longitude'],
         'city'      => user['City'],
         'state'     => user['State'],
         'type'      => user['Type']
     })
      end

      def authorize_params
        super.tap do |params|
          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      private
        def user
          @user ||= ::Dwolla::Users.me(access_token.token)
        rescue ::Dwolla::DwollaError => e
          raise CallbackError.new(e, e.message)
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
