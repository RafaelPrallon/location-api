json.array! @locations do |location|
  json.id location.id
  json.name location.name
  json.street location.street
  json.number location.number
  json.complement location.complement
  json.city location.city
  json.state location.state
  json.latitude location.latitude
  json.longitude location.longitude
  json.rating location.ratings.average(:grade) || 0.0
end
