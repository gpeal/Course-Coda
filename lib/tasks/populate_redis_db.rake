desc "Populate the redis database with search keys"
task :populate_redis_db => :environment do

  REDIS.flushall

  Title.all.each do |title|
    key = "TITLE #{title.subject.abbrev} #{title.to_s.downcase} |" + "%05d" % title.id
    REDIS.set(key, title.id)
    puts key
  end

  Professor.all.each do |professor|
    key = "PROFESSOR #{professor.to_s.downcase} |" + "%05d" % professor.id
    REDIS.set(key, professor.id)
    puts key
  end
end