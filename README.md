# README

Rails application of an locations API where an user can add locations, see those locations ordered by name or by distance of a provided coordinate and  te user can add/edit/delete ratings for a location and see those ratings.

It was made using Rails 6.1.3.2 and Ruby 3.0.0p0 and it uses:

- JWT for authentication through [devise](https://github.com/heartcombo/devise) and [devise jwt](https://github.com/waiting-for-dev/devise-jwt)

- [Geocoder](https://github.com/alexreisner/geocoder) for geolocalization

- [Apipie](https://github.com/Apipie/apipie-rails) for api documentation

- PostgreSQL as Database

Link to it running on heroku: https://location-api-rpmx.herokuapp.com
To read docummentation, use the /docs endpoint
