require 'active_support/concern'
module Cache
  extend ActiveSupport::Concern
  included do
    around_filter :cache_response
  end

  def cache_response
    key = params.to_s
    json = CACHE.get(key)
    unless json.nil?
      render :json => json
      return
    end
    yield
    CACHE.set(key, self.response_body[0])
    # set the ttl to a year
    CACHE.expire(key, 31557600)
  end
end