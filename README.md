# Rails Cache Migrator

A tool to migrate cache data between Rails 3 and 4

If you are not clearing your cache when you migrate to Rails 4 the cache entries
may not be readable. This happens because Rails 3 used `Marshal.dump` to encode the
entries and Rails 4 expects them just to be serialized/deserialize by the cache store.
So your cached data from Rails 3 will end up being a Marshal string not an object.

See https://github.com/rails/rails/issues/17923 for a description of the issue.

This resolves the issue by providing a migrator class that you can use to migrate your
keys.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_cache_migrator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_cache_migrator

## Usage
Presuming you have an effective way of iterating your cache keys (see below), you can create an instance
of the migrator and then migrate each key.


```ruby
migrator = RailsCacheMigrator::Migrator.new(
    [:redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }],
    :mem_cache_store
)

cache_keys.each do |cache_key|
  migrator.migrate(cache_key)
end
```

[ActiveSupport::Cache::Store](http://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html)
does not provide a way to access the keys of the store directly, because this may be an intensive
operation, like it is on [Redis](http://redis.io/commands/keys).

You could implement [a system to store the keys separately](http://stackoverflow.com/a/9603083/201911),
which is what we had in place. If you didn't do that then you could try something like this if your
store supports it:

```ruby
Rails.cache.instance_variable_get(:@data).keys
```

The two parameters to the `Migrator` constructor are cache specs as you would use in
your `config.cache_store` line in your Rails `config/application.rb` file. To add
parameters to one of the cache instances, you can make it an array.

The following are all valid options:

    [:redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }]

    :mem_cache_store

    [:file_store, '/tmp/cache']

    MyOwnCacheStore.new

See [ActiveSupport::Cache.lookup_store](http://api.rubyonrails.org/classes/ActiveSupport/Cache.html#method-c-lookup_store)
for details.

If you are doing this on a production system where cache data is changing you may need to find a way
to collect and process the changed keys as well. Although the migrator is pretty quick, so it may be
OK to miss a few cache entries.

## Security

- Do not assign a Rail 4 cache to the old cache instance. Someone could inject data into your cache server that gets
  marshaled by this code when the data was not expected to be marshaled.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt
that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rails_cache_migrator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
