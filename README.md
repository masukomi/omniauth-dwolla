# OmniAuth Dwolla

Dwolla OAuth2 Strategy for OmniAuth 1.0.

## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth-dwolla'
```

Then `bundle install`.

## Usage

`OmniAuth::Strategies::Dwolla` is simply a Rack middleware. Read the OmniAuth 1.0 docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dwolla, ENV['DWOLLA_KEY'], ENV['DWOLLA_SECRET']
end
```
