uri = URI.parse(REDIS_CONFIG['url'])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
