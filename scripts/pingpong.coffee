# Description 
# Setting up ping pong teams 

maxplayers = 4 
Array::shuffle = -> @sort -> 0.5 - Math.random()
Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1
playersAreReady = (players) -> (maxplayers - players.length) <= 0
startGame = (message, robot) -> 
  robot.brain.data.players.shuffle()
  message.send "(pingpong) #{robot.brain.data.players[0]} & #{robot.brain.data.players[1]} vs #{robot.brain.data.players[2]} & #{robot.brain.data.players[3]}"
  robot.brain.data.players = []

module.exports = (robot) ->
  robot.brain.data.players = []
  robot.hear /^(pingpong) ?(.*)/i, (msg) ->
    sender = msg.message.user.name
    command = msg.match[2].split(" ")[0]
    if (command is "")
      if (robot.brain.data.players.length is 0)
        robot.brain.data.players.push sender
        msg.send "(pingpong) #{robot.brain.data.players[0]} wants to play. Anyone else wants to play ping pong?"
      else
        if (sender in robot.brain.data.players)
          msg.send "(pingpong) #{sender} REALLY wants to play. #{maxplayers - robot.brain.data.players.length} More needed"
        else
          robot.brain.data.players.push sender
          if (playersAreReady(robot.brain.data.players))
            startGame(msg, robot)
          else
            msg.send "(pingpong) #{sender} is game! #{maxplayers - robot.brain.data.players.length} more needed"
    else
      switch command
        when "queue", "kø"
          msg.send "(pingpong) #{robot.brain.data.players.join(', ')} wants to play. #{maxplayers - robot.brain.data.players.length} more needed"
        when "remove", "fjern"
          message = msg.match[2]
          commandData = if message.indexOf(' ') is -1 then '' else message.substring(message.indexOf(' ') + 1)
          if(commandData.length is 0)
            sender = msg.message.user.name
            robot.brain.data.players.remove(sender)
          else
            sender = commandData
            robot.brain.data.players.remove(sender)

          msg.send "(pingpong) #{sender} is a chicken. #{maxplayers - robot.brain.data.players.length} More needed"
        when "add"
          commandData = msg.match[2].substring(msg.match[2].indexOf(' ') + 1)
          players = commandData.split(",")
          robot.brain.data.players.push player.trim() for player in players
          if (playersAreReady(robot.brain.data.players))
            startGame(msg, robot)
          else
            msg.send "(pingpong) #{robot.brain.data.players.join(', ')} wants to play. #{maxplayers - robot.brain.data.players.length} more needed"
        else
          msg.send "#{command} is an unknown command"
