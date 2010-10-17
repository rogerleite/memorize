require 'test/test_helper'

class ModelSample
  extend Memorize::Keys
end

class MemorizeController < ActionController::Base

  memorize_action :index, :cache_path => lambda { |c| MockSupport.path }
  memorize_action :index2, :key_builder => ModelSample
  memorize_action :index3, :key_builder => ModelSample, :params => [:format]
  memorize_action :show, :key_builder => ModelSample, :key_param => :id, :params => [:format]

  def index
    @cache_this = MockTime.now.to_f.to_s
    render :text => @cache_this
  end

  def index2
    @cache_this = MockTime.now.to_f.to_s
    render :text => @cache_this
  end

  def index3
    @cache_this = "#{MockTime.now.to_f.to_s} format: #{params[:format]}"
    render :text => @cache_this
  end

  def show
    @cache_this = "#{MockTime.now.to_f.to_s} id: #{params[:id]} format: #{params[:format]}"
    render :text => @cache_this
  end

end

module ActionAssertions

  def test_action_with_cache_path
    Memorize.cache_store.clear
    MockSupport.path = "index"
    get :index
    assert_body_is_cached :cache_key => "index", :action_name => lambda { get :index }
  end

  def test_action_with_key_builder_only
    Memorize.cache_store.clear
    get :index2
    assert_body_is_cached :cache_key => "ModelSample/index2", :action_name => lambda { get :index2 }
  end

  def test_action_with_key_builder_and_params
    Memorize.cache_store.clear
    get :index3
    assert_body_is_cached :cache_key => "ModelSample/index3", :action_name => lambda { get :index3 }

    get :index3, :format => :rss
    assert_body_is_cached :cache_key => "ModelSample/index3/rss", :action_name => lambda { get :index3, :format => :rss }

    assert_equal ["ModelSample/index3", "ModelSample/index3/rss"], ModelSample.cache_entries(:index3)
  end

  def test_action_with_key_builder_and_key_param
    Memorize.cache_store.clear
    #simulating some previous access
    get :index
    get :index3
    get :index3, :format => :rss

    get :show, :id => 123
    assert_body_is_cached :cache_key => "ModelSample/show/123", :action_name => lambda { get :show, :id => 123 }

    get :show, :id => 123, :format => :xml
    assert_body_is_cached :cache_key => "ModelSample/show/123/xml", :action_name => lambda { get :show, :id => 123, :format => :xml }

    assert_equal ["ModelSample/show/123", "ModelSample/show/123/xml"], ModelSample.cache_entries(:show, :key => 123)
  end

  private

  def assert_body_is_cached(options)
    cache_key = options.delete(:cache_key)

    cached_time = assigns(:cache_this)
    assert_equal cached_time, @response.body
    assert Memorize.cache_store.exist?(cache_key)
    reset!

    options.delete(:action_name).call
    assert_equal cached_time, @response.body
  end

  def reset!
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @controller = MemorizeController.new
  end

end

#test with Rails default cache store
class MemoryActionTest < ActionController::TestCase
  def setup
    Memorize.cache_store = ActiveSupport::Cache.lookup_store(:memory_store)
    reset!
  end
  include ActionAssertions
end

#test with Memcached cache store
class MemcachedActionTest < ActionController::TestCase
  def setup
    raise "Memcached should be started to test !" if `ps aux | grep memcached | grep -v grep`.empty?
    Memorize.cache_store = ActiveSupport::Cache.lookup_store(:mem_cache_store, '127.0.0.1:11211')
    reset!
  end
  include ActionAssertions
end

