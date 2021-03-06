# Description:
#   Let hubot tell you where to go for lunch.
#
# Commands:
#   hubot lunch me - find a place to eat
#   hubot lunch me tacos - find what you are in the mood for
#   hubot houston lunch me - find a place in Houston, too!

yelp = require "yelp"

# Generate new keys at https://www.yelp.com/developers/manage_api_keys
yelp = yelp.createClient
  consumer_key: process.env.HUBOT_YELP_CONSUMER_KEY
  consumer_secret: process.env.HUBOT_YELP_CONSUMER_SECRET
  token: process.env.HUBOT_YELP_TOKEN
  token_secret: process.env.HUBOT_YELP_TOKEN_SECRET

austinOffice = '10415 Morado Circle, Austin, TX 78759'
houstonOffice = '10111 Richmond Ave, Houston, TX 77042'
dallasOffice = '5000 Quorum Drive Suite 300, Dallas, TX 75254'
monterreyOffice = 'Av. Eugenio Garza Sada 3820, Mas Palomas, 64860 Monterrey, NL, Mexico'

terms =
  radius: 8000 #meters, ~5 miles
  limit: 20
  category: 'food'

barks = [
  "How about {0}?",
  "Are you in the mood for {0}?",
  "When's the last time you had {0}?",
  "If I were not an artificial intelligence, I would eat at {0}.",
  "You should get {0}. (awyeah)",
  "Perhaps you would like something from {0}.",
  "Have you ever tried {0}?"
]

module.exports = (robot) ->
  robot.respond /lunch help$/i, (msg) ->
    msg.send "/quote examples: \n\thsbot lunch me\n\thsbot houston lunch me\n\thsbot dallas lunch me tacos\n\nusage:\n\toptional city name (dallas, austin, houston, monterrey). Defaults to Austin.\n\toptional additional search terms can be added at the end"

  robot.respond /(?:(austin|houston|dallas|monterrey)[- ])?lunch me([- ](.+))?/i, (msg) ->
    terms.cc = 'US'
    terms.term = msg.match[3] or 'lunch';
    switch msg.match[1]
      when 'dallas'
        terms.location = dallasOffice
      when 'houston'
        terms.location = houstonOffice
      when 'monterrey'
        terms.location = monterreyOffice
        terms.cc = 'MX'
      else
        terms.location = austinOffice

    # See http://www.yelp.com/developers/documentation/v2/search_api
    yelp.search terms, (err, body) ->
      places = body.businesses;
      if err? || !places?
        msg.send "Error with the response from Yelp (sadpanda)"
      if places.length == 0
        msg.send "I can't find any lunch places that are #{terms.term}. (shrug)"
      else
        place = msg.random places
        bark = msg.random barks
        msg.send bark.replace("{0}", place.name) + " " + place.url
