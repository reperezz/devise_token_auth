module DeviseTokenAuth
  class RedisTokens
    def initialize(id)
      @id = id
      @prefix = "tokens:#{id}"
    end

    def [](key)
      $redis.exists(reference(key)) ? $redis.hgetall(reference(key)) : nil
    end

    def []=(key, value)
      $redis.hmset(reference(key), *value.to_a.flatten)
    end

    def keys
      full_keys.map{|key| root_key(key)}
    end

    def delete(key)
      $redis.del(reference(key))
    end

    def delete_if(*args, &block)
      hash = root_hash
      hash.delete_if(*args, &block)
      keys_to_delete = (keys - hash.keys).map{|key| reference(key)}
      $redis.del(*keys_to_delete)
    end

    def root_hash
      hash = {}
      full_keys.each do |full_key|
        hash[root_key(full_key)] = $redis.hgetall(full_key)
      end
      return hash
    end

    def method_missing(meth, *args, &block)
      root_hash.send(meth, *args, &block)
    end

    private

    def full_keys
      $redis.keys("#{@prefix}:*")
    end

    def reference(key)
      "#{@prefix}:#{key}"
    end

    def root_key(key)
      key.split(':').last
    end
  end
end
