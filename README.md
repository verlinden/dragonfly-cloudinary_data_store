## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dragonfly-cloudinary_data_store'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dragonfly-cloudinary_data_store

## Usage

Set up Cloudinary account, download your cloudinary.yml, and add this to your Dragonfly initializer:
```ruby
  Dragonfly.app.configure do
    datastore Dragonfly::CloudinaryDataStore.new
  end
```

## Optional configuration

Set can setup the data store to automatically create path prefix (Cloudinary folders) based on the current Rails environment:
```ruby
  datastore Dragonfly::CloudinaryDataStore.new(env_prefix: true)
```

## TODO
Add some tests

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/verlinden/dragonfly-cloudinary_data_store


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
