desc "Splits the original feedback for each section into its own model"
task :clear_cache => :environment do
  CACHE.flushall
end