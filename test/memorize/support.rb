ActionController::Base.perform_caching = true
ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/:action/:id'
end

class MockTime < Time
  # Let Time spicy to assure that Time.now != Time.now
  def to_f
    super+rand
  end
end

class MockSupport
  cattr_accessor :path
end

#class Rails      #this mock only exists for initializer
#  def self.cache
#    nil
#  end
#end
