module Memorize

  class << self

    def cache_store
      @cache_store || ActiveSupport::Cache.lookup_store(:memory_store)
    end

    def cache_store=(cs)
      @cache_store = cs
    end

  end

end

require 'memorize/keys'
require 'memorize/action'

#add memorize_action to controllers
ActionController::Base.extend Memorize::Action
