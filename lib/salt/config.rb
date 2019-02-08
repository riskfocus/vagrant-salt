require 'salt'

# config class to merge configurations
module Salt
  class Config < Hash
    def initialize(*h_list)
      return if h_list.empty?
      h_list.compact.each  { |h| self.merge!(h) }
    end

    def has_keys?(mandatory_keys)
      # this should be a one-liner with map or each
      return (mandatory_keys - self.keys).empty?
    end
    
  end
end
