json.array! @titles do |title|
  json.id title.id
  json.name title.to_s
end