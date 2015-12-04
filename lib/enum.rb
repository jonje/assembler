=begin
This enum code comes from 
http://stackoverflow.com/questions/265725/what-is-the-best-way-to-handle-constants-in-ruby-when-using-rails
=end

class Enum
  def Enum.add_item(key,value)
    @hash ||= {}
    @hash[key] = value
  end

  def Enum.const_missing(key)
    @hash[key]
  end

  def Enum.each
    @hash.each {|key,value| yield(key,value)}
  end

  def Enum.values
    @hash.values || []
  end

  def Enum.keys
    @hash.keys || []
  end

  def Enum.[](key) 
    @hash[key]
  end
end