module.exports = (robot) ->
  robot.hear /90S$/i, (msg) ->
    msg.send "http://i.imgur.com/ckhWDlA.png"

