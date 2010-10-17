module Memorize

  #  Memorize padroniza e mantém as entradas associadas a um "grupo" e "key".
  #  Ao extender o Memorize::Keys, os seguintes métodos ficarão disponíveis:
  #  
  #   Model.cache_key(:group_id)
  #   Model.cache_key(:group_id, :key => "key")
  #   
  #   Model.cache_entries(:group_id)
  #   Model.cache_entries(:group_id, :key => "key")
  module Keys

    def cache_key(group, options = {})
      param_key = options.delete(:key)
      group_key = build_group_key(group, param_key)
      cache_key = build_cache_key(group, param_key, options.delete(:params))
      update_cache_entry(group_key, cache_key)
      cache_key
    end

    def cache_entries(group, options = {})
      group_key = build_group_key(group, options.delete(:key))
      Memorize.cache_store.read(group_key) || []
    end

    def cache_expires(group, options = {})
      group_key = build_group_key(group, options.delete(:key))
      Memorize.cache_store.delete(group_key)
    end
    
    private

    def update_cache_entry(group_key, cache_key)
      entries = (Memorize.cache_store.read(group_key) || [])
      unless entries.include?(cache_key)
        entries = entries.dup if entries.frozen?
        entries << cache_key
        Memorize.cache_store.write(group_key, entries)
      end
    end

    def build_cache_key(group, key, *params)
      cache_key = "#{self.to_s}/#{group.to_s}"
      cache_key << "/#{key}" if key
      params = params.flatten.compact
      cache_key << "/#{params.join("/")}" unless params.blank?
      cache_key
    end

    def build_group_key(group, key = nil)
      group_key = "#{self.to_s}/keys/#{group.to_s}"
      group_key << "/#{key}" if key
      group_key
    end
  end

end
