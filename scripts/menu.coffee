# Description:
#   Gets the menu of the day
#
# Commands:
#   hubot menu

module.exports = (robot) ->
 robot.respond /(menu|mad|food)$/i, (msg) ->
  msg.send "https://www.facebook.com/AntonEmilMad"
