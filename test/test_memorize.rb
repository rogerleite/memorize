require 'test/test_helper'

class TestCache
  extend Memorize::Keys
end

module MemorizeAssertions

  def test_internal_build_group_key
    assert_equal "TestCache/keys/index",          TestCache.send(:build_group_key, :index)
    assert_equal "TestCache/keys/show/slug-test", TestCache.send(:build_group_key, :show, "slug-test")
    assert_equal "TestCache/keys/show/123",       TestCache.send(:build_group_key, :show, 123)
  end
  def test_internal_build_cache_key
    assert_equal "TestCache/index",                 TestCache.send(:build_cache_key, :index, nil)
    assert_equal "TestCache/index/category/1/html", TestCache.send(:build_cache_key, :index, nil, ["category", "1", "html"])
    assert_equal "TestCache/index/category/html",   TestCache.send(:build_cache_key, :index, nil, ["category", nil, "html"])
    assert_equal "TestCache/show/slug-test/rss",    TestCache.send(:build_cache_key, :show, "slug-test", ["rss"])
  end

  def test_cache_keys_should_be_unique
    TestCache.cache_key :index
    TestCache.cache_key :index
    assert_equal ["TestCache/index"], TestCache.cache_entries(:index) 
  end
  def test_cache_keys_should_be_grouped
    TestCache.cache_key :index
    TestCache.cache_key :index, :params => ["category", "html"]
    assert_equal ["TestCache/index", "TestCache/index/category/html"], TestCache.cache_entries(:index) 
  end
  def test_cache_keys_should_be_grouped_diff_calls
    TestCache.cache_key :index
    TestCache.cache_key :index, :params => ["category", "html"]
    TestCache.cache_key :show, :key => "test", :params => ["category", "html"]
    assert_equal ["TestCache/index", "TestCache/index/category/html"], TestCache.cache_entries(:index)
  end

  def test_should_return_an_empty_array
    assert_equal [], TestCache.cache_entries(:index)
  end

  def test_should_use_memory_store_if_no_store
    Memorize.cache_store = nil
    assert_equal [], TestCache.cache_entries(:index)
  end

  def test_expires_group_should_delete_cache
    TestCache.cache_key :index
    TestCache.cache_key :index, :params => ["category", "html"]
    TestCache.cache_expires(:index)
    assert_equal [], TestCache.cache_entries(:index)
  end
  def test_expires_group_and_key_param_should_delete_cache
    TestCache.cache_key :show, :key => "test", :params => ["category", "html"]
    TestCache.cache_expires(:show, :key => "test")
    assert_equal [], TestCache.cache_entries(:show, :key => "test")
  end

end

class MemoryMemorizeTest < Test::Unit::TestCase
  def setup
    Memorize.cache_store = ActiveSupport::Cache.lookup_store(:memory_store)
    Memorize.cache_store.clear
  end
  include MemorizeAssertions
end

class MemcachedMemorizeTest < Test::Unit::TestCase
  def setup
    raise "Memcached should be started to test !" if `ps aux | grep memcached | grep -v grep`.empty?
    Memorize.cache_store = ActiveSupport::Cache.lookup_store([:mem_cache_store, '127.0.0.1:11211'])
    Memorize.cache_store.clear
  end
  include MemorizeAssertions unless `ps aux | grep memcached | grep -v grep`.empty?
end
