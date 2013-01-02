require Rails.root.join('lib', 'alchemy_api.rb')

ALCHEMY = AlchemyAPI.new
ALCHEMY.setAPIKey(ALCHEMY_CONFIG['key'])