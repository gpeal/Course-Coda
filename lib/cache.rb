require 'active_support/concern'
module Cache
  extend ActiveSupport::Concern
  included do
    around_filter :cache_response
  end

  def cache_response
    if Rails.env.production?
      json = CACHE.get(params.to_s)
      if json.nil?
        yield
        CACHE.set(key, self.response_body[0])
        # set the ttl to a year
        CACHE.expire(key, 31557600)
      else
        logger.info "Returning result from cache"
        render :json => json
        return
      end
    else # not production
      yield
    end
    end
end