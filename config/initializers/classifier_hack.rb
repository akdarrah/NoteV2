# Monkey-path for Classifier Gem
# Remove for next version of classifier or if classifier is no longer neeeded.

class Array
  def sum(identity = 0, &block)
    return identity unless size > 0

    if block_given?
      map(&block).sum
    else
      a = inject( nil ) { |sum,x| sum ? sum+x : x }
      # Hack to remove the to_f error
      a.is_a?(Array) ? a : a.to_f
    end
  end
end
