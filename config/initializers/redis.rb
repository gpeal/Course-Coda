uri = URI.parse(REDIS_CONFIG['search_url'])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

uri = URI.parse(REDIS_CONFIG['cache_url'])
CACHE = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
