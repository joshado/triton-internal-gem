# This class has been permamently borrowed from Sinatra, that repo is MIT licensed
# and has these copyright notices:
#
#     Copyright (c) 2007, 2008, 2009 Blake Mizerany
#     Copyright (c) 2010-2017 Konstantin Haase
#     Copyright (c) 2015-2017 Zachary Scott
#

class IndifferentHash < Hash
  def self.[](*args)
    new.merge!(Hash[*args])
  end

  def initialize(*args)
    super(*args.map(&method(:convert_value)))
  end

  def default(*args)
    super(*args.map(&method(:convert_key)))
  end

  def default=(value)
    super(convert_value(value))
  end

  def assoc(key)
    super(convert_key(key))
  end

  def rassoc(value)
    super(convert_value(value))
  end

  def fetch(key, *args)
    super(convert_key(key), *args.map(&method(:convert_value)))
  end

  def [](key)
    super(convert_key(key))
  end

  def []=(key, value)
    super(convert_key(key), convert_value(value))
  end

  alias_method :store, :[]=

  def key(value)
    super(convert_value(value))
  end

  def key?(key)
    super(convert_key(key))
  end

  alias_method :has_key?, :key?
  alias_method :include?, :key?
  alias_method :member?, :key?

  def value?(value)
    super(convert_value(value))
  end

  alias_method :has_value?, :value?

  def delete(key)
    super(convert_key(key))
  end

  def dig(key, *other_keys)
    super(convert_key(key), *other_keys)
  end if method_defined?(:dig) # Added in Ruby 2.3

  def fetch_values(*keys)
    super(*keys.map(&method(:convert_key)))
  end if method_defined?(:fetch_values) # Added in Ruby 2.3

  def values_at(*keys)
    super(*keys.map(&method(:convert_key)))
  end

  def merge!(other_hash)
    return super if other_hash.is_a?(self.class)

    other_hash.each_pair do |key, value|
      key = convert_key(key)
      value = yield(key, self[key], value) if block_given? && key?(key)
      self[key] = convert_value(value)
    end

    self
  end

  alias_method :update, :merge!

  def merge(other_hash, &block)
    dup.merge!(other_hash, &block)
  end

  def replace(other_hash)
    super(other_hash.is_a?(self.class) ? other_hash : self.class[other_hash])
  end

  private

  def convert_key(key)
    key.is_a?(Symbol) ? key.to_s : key
  end

  def convert_value(value)
    case value
    when Hash
      value.is_a?(self.class) ? value : self.class[value]
    when Array
      value.map(&method(:convert_value))
    else
      value
    end
  end
end
