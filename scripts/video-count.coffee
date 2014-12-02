# Description:
#  Get video count
#
# Commands:
#   hubot balls
$ = require('jquery')(require("jsdom").jsdom().parentWindow)

module.exports = (robot) ->
 robot.hear /balls$/i, (msg) ->
  msg.http("https://www.youtube.com/watch?v=4nzDQIpGo6c&feature=youtu.be")
   .get() (error, response, body) ->
    if(error)
      msg.send error
    else
      count = $(body).find('.watch-view-count').text()
      msg.send count
