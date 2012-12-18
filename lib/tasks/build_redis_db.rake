desc "Populate the redis database with search keys"
task :populate_redis_db => :environment do
  Section.all.each do |section|
    key = "SECTION #{section.to_s.downcase}"
    REDIS.set(key, section.id)
    puts key
  end

  Professor.all.each do |professor|
    key = "PROFESSOR #{professor.to_s.downcase}"
    REDIS.set(key, professor.id)
    puts key
  end
end