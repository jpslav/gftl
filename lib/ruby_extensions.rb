class Array
  # Takes a block to make a hash out of this array, e.g.:
  #
  #   myArray = [1,2,5]
  #   myArray.make_hash{|a| [a, a*2]}  # => {1=>2, 2=>4, 5=>10}
  #
  def make_hash
     hash = self.collect{|item| yield(item)}
     hash = Hash[*hash.flatten]
  end
  
end