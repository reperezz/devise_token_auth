module Devise
  # Tokens in DB or tokens in Redis. By default in database
  # If tokens_in_db is false then $redis must exist and be something like the following:
  # Example: $redis = Redis::Namespace.new('myApp', redis: Redis.new(driver: :hiredis))
  mattr_accessor :tokens_in_db
  @@tokens_in_db = true
end