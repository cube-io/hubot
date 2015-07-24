# Description:
#   Who owes cake
#
# Commands:
#   hubot cake

moment = require('moment')

module.exports = (robot) ->
	robot.brain.data.cakes = []
	untrustedUsers = []

	robot.respond /cake add (.*)/i, (msg) ->
		if (msg.message.user.name in untrustedUsers)
			msg.reply "I'm afraid I can't let you do that."
		else
			cake =
				desc: msg.match[1]
				date: moment().format('YYYY/MM/DD')
				paid: false
			robot.brain.data.cakes.push cake
			msg.reply "Okay, got it"

	robot.respond /cake$/i, (msg) ->
		response = ""
		for cake, index in robot.brain.data.cakes when cake.paid is false
			response += "#{index} - #{cake.date}: #{cake.desc}"
			response += '\n' unless index == robot.brain.data.cakes.length - 1
		msg.send response

	robot.respond /cake pay (\d+)/i, (msg) ->
		if (msg.message.user.name in untrustedUsers)
			msg.reply "I'm afraid I can't let you do that."
		else
			robot.brain.data.cakes[msg.match[1]].paid = true
			msg.reply "Okay, the cake is paid"
