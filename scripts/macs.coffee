# Description:
#   Because, it's just (supposed to) work!

odds  = [1...100]

pics = ["http://i.imgur.com/fEbhFJs.png",
		"http://i.imgur.com/NSj5Yed.jpg",
		"http://i.imgur.com/ET7lt18.png",
		"http://i.imgur.com/mFh3qzV.jpg",
		"http://i.imgur.com/KEgZLy1.jpg"
		]

module.exports = (robot) ->
	robot.hear /it just works/i, (msg) ->
		val = msg.random odds
		if val > 50
			msg.send "#{pics[val%5]}"