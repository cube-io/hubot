# Description:
#   Who owes cake
#
# Commands:
#   hubot cake

module.exports = (robot) ->
	robot.respond /cake$/i, (msg) ->
		msg.http("https://gist.githubusercontent.com/Leh2/a449897753692ff516f7/raw/cake.json")
			.get() (error, response, body) ->
				cakes = JSON.parse(body)
				i = 0
				while i < cakes.length
					cake = cakes[i]
					if !cake.Paid
						msg.send cake.Name + " skylder kage. (" + cake.Why + ")"
					i++
