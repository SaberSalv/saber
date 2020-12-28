class Hash
  # From Rails 4.0

  # Return a new hash with all keys converted by the block operation.
  # This includes the keys from the root hash and from all
  # nested hashes.
  #
  #  hash = { person: { name: 'Rob', age: '28' } }
  #
  #  hash.deep_transform_keys{ |key| key.to_s.upcase }
  #  # => { "PERSON" => { "NAME" => "Rob", "AGE" => "28" } }
  def deep_transform_keys(&block)
    result = {}
    each do |key, value|
      result[yield(key)] = value.is_a?(Hash) ? value.deep_transform_keys(&block) : value
    end
    result
  end

  # Destructively convert all keys by using the block operation.
  # This includes the keys from the root hash and from all
  # nested hashes.
  def deep_transform_keys!(&block)
    keys.each do |key|
      value = delete(key)
      self[yield(key)] = value.is_a?(Hash) ? value.deep_transform_keys!(&block) : value
    end
    self
  end

  # Return a new hash with all keys converted to strings.
  # This includes the keys from the root hash and from all
  # nested hashes.
  #
  #   hash = { person: { name: 'Rob', age: '28' } }
  #
  #   hash.deep_stringify_keys
  #   # => { "person" => { "name" => "Rob", "age" => "28" } }
  def deep_stringify_keys
    deep_transform_keys{ |key| key.to_s }
  end

  # Destructively convert all keys to strings.
  # This includes the keys from the root hash and from all
  # nested hashes.
  def deep_stringify_keys!
    deep_transform_keys!{ |key| key.to_s }
  end

  # Return a new hash with all keys converted to symbols, as long as
  # they respond to +to_sym+. This includes the keys from the root hash
  # and from all nested hashes.
  #
  #   hash = { 'person' => { 'name' => 'Rob', 'age' => '28' } }
  #
  #   hash.deep_symbolize_keys
  #   # => { person: { name: "Rob", age: "28" } }
  def deep_symbolize_keys
    deep_transform_keys{ |key| key.to_sym rescue key }
  end

  # Destructively convert all keys to symbols, as long as they respond
  # to +to_sym+. This includes the keys from the root hash and from all
  # nested hashes.
  def deep_symbolize_keys!
    deep_transform_keys!{ |key| key.to_sym rescue key }
  end
end
