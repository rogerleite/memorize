module Memorize

  #  Exemplos de uso:
  #  
  #   class TestController < ApplicationController
  #     memorize_action :index, :key_builder => Article, :params => [:category, :page, :format]
  #     memorize_action :show,  :key_builder => Article, :key_param => :slug, :params => [:page, :format]
  #     memorize_action :index, :cache_path => lambda { |controller| "my_key_#{controller.params.to_s}" }
  #   end
  
  module Action

    def memorize_action(*actions)
      return unless self.perform_caching
      options = actions.extract_options!
      filter_options = { :only => actions, :if => options.delete(:if), :unless => options.delete(:unless) }

      memorize_filter = MemorizeFilter.new(options)
      around_filter(filter_options) do |controller, action|
        memorize_filter.filter(controller, action)
      end
    end

    class MemorizeFilter #:nodoc:

      def initialize(options)
        @cache_path = options.delete(:cache_path)
        @key_builder = options.delete(:key_builder)
        @key_param = options.delete(:key_param)
        @key_params = options.delete(:params) || []
        @cache_options = options
      end

      def filter(controller, action)
        cache_path = eval_cache_path(controller)
        cached = before(cache_path, controller)
        unless cached
          action.call
          after(cache_path, controller) if caching_allowed?(controller)
        end
      end

      def before(cache_path, controller)
        if (cache = Memorize.cache_store.read(cache_path))
          options = {:layout => false, :text => cache}
          controller.__send__(:render, options)
        end
        !!cache
      end

      def after(cache_path, controller)
        Memorize.cache_store.write cache_path, controller.response.body, @cache_options
      end

      private

      def eval_cache_path(controller)
        return @cache_path.call(controller) if @cache_path.respond_to?(:call)
        unless @key_builder.respond_to?(:cache_key)
          throw "Invalid 'key_builder' parameter. It should respond to 'cache_key' method."
        end
        group = controller.action_name.to_sym
        key = controller.params[@key_param]
        params = @key_params.collect { |param| controller.params[param] }
        @key_builder.cache_key(group, :key => key, :params => params)
      end

      def caching_allowed?(controller)
        controller.request.get? && controller.response.status.to_i == 200
      end

    end

  end

end
