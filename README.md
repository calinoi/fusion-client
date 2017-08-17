# Fusion::Client

This gem provides a client for the custom API that Calinoi has built on
top of Fusion Pro.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fusion-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fusion-client

## Usage

Step 1: Configure the gem (optional)

`Fusion::Client` requires 3 parameters for initialization: 
1. `url`: The Calinoi url to send requests to.
2. `username`: Your company's username.
3. `password`: Your company's password.

These 3 parameters can be passed to the initializer when instantiating a
client or configured using an initializer (recommended). 

Sample Initializer: `config/initializers/fusion_client.rb`
```ruby
Fusion::Client.configure do |config|
  config.url = [URL]
  config.username = [your username]
  config.password = [your password]
end
```

Step 2: Instantiate the client

Instantiating the client is pretty straightforward:
```ruby
client = Fusion::Client.new
```
or if you didn't use an initializer you will need to pass those
configuration values in here:
```ruby
client = Fusion::Client.new(username: [your username], password: [your
password], url: [URL])
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/calinoi/fusion-client.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

