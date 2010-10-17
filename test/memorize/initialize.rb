#require 'memorize'

#Some examples to set Memorize cache_store:
#Memorize.cache_store = Rails.cache
#Memorize.cache_store = ActiveSupport::Cache.lookup_store(:memory_store)
#Memorize.cache_store = ActiveSupport::Cache.lookup_store(:mem_cache_store, '127.0.0.1:11211')

#Your models can be 'Keys factories'
ActiveRecord::Base.extend Memorize::Keys

