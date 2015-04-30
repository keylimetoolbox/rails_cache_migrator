module RailsCacheMigrator
  class Migrator

    # Public: A tool to migrate cache keys between a Rails 3 and Rails 4 cache.
    #
    # rails_3: A cache spec or instance for the Rails 3 cache to read from.
    # rails_4: A cache spec or instance for the Rails 4 cache to write to.
    #
    # The cache spec can look like a cache spec for your `config.cache_store`
    # line in your Rails `config/application.rb` file. To add parameters to
    # one of the specs, you can make it an array.
    #
    # The following are all valid options:
    #    [:redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }]
    #    :mem_cache_store
    #    [:file_store, '/tmp/cache']
    #    MyOwnCacheStore.new
    def initialize(rails_3, rails_4)
      @old_store = ActiveSupport::Cache.lookup_store rails_3
      @new_store = ActiveSupport::Cache.lookup_store rails_4
    end

    def migrate(key)
     @new_store.write(key, deserialize_entry(@old_store.read(key)))
    end

    private

    def deserialize_entry(raw_value)
      return nil unless raw_value
      Marshal.load(raw_value) rescue raw_value
    end
  end
end
