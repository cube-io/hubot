# Description 
# Setting up ping pong teams 

maxplayers = 4 
Array::shuffle = -> @sort -> 0.5 - Math.random()
Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1
playersAreReady = (players) -> (maxplayers - players.length) <= 0
startGame = (message, robot) -> 
  updateMatchStatistic player, robot for player in robot.brain.data.players
  robot.brain.data.players.shuffle()
  message.send "#{emoticon} #{robot.brain.data.players[0]} & #{robot.brain.data.players[1]} vs #{robot.brain.data.players[2]} & #{robot.brain.data.players[3]}"
  robot.brain.data.shuffleCopy = robot.brain.data.players[..]
  robot.brain.data.players = []
shufflePlayers = (message, robot) ->
  robot.brain.data.shuffleCopy.shuffle()
  message.send "#{emoticon} #{robot.brain.data.shuffleCopy[0]} & #{robot.brain.data.shuffleCopy[1]} vs #{robot.brain.data.shuffleCopy[2]} & #{robot.brain.data.shuffleCopy[3]}"
findRank = (player, robot) ->
  playerScore = robot.brain.data.rankings[player]
  position = 1
  position += (robot.brain.data.rankings[key] > playerScore ? 1 : 0) for key in Object.keys(robot.brain.data.rankings)
  position
updateMatchStatistic = (player, robot) ->
  if robot.brain.data.playerStatistics[player]
    robot.brain.data.playerStatistics[player].matches++
  else
    robot.brain.data.playerStatistics[player] = matches: 1
emoticon = ":pingpong:"

module.exports = (robot) ->
  robot.brain.data.players = []
  robot.brain.data.shuffleCopy = []
  robot.brain.data.playerStatistics = {}
  robot.brain.data.rankings = {}
  robot.hear /^(ping|pong|gong|pling|plang|pang|ting|tong|ding|p){2} ?(.*)/i, (msg) ->
    sender = msg.message.user.name
    command = msg.match[2].split(" ")[0]
    if (command is "")
      if (robot.brain.data.players.length is 0)
        robot.brain.data.players.push sender
        msg.send "#{emoticon} #{robot.brain.data.players[0]} wants to play. Anyone else wants to play ping pong?"
        robot.brain.data.shuffleCopy = []
      else
        if (sender in robot.brain.data.players)
          msg.send "#{emoticon} #{sender} REALLY wants to play. #{maxplayers - robot.brain.data.players.length} more needed"
        else
          robot.brain.data.players.push sender
          if (playersAreReady(robot.brain.data.players))
            startGame(msg, robot)
          else
            msg.send "#{emoticon} #{sender} is game! #{maxplayers - robot.brain.data.players.length} more needed"
    else
      switch command
        when "queue", "kø"
          msg.send "#{emoticon} #{robot.brain.data.players.join(', ')} wants to play. #{maxplayers - robot.brain.data.players.length} more needed"
        when "remove", "fjern"
          message = msg.match[2]
          commandData = if message.indexOf(' ') is -1 then '' else message.substring(message.indexOf(' ') + 1)
          if(commandData.length is 0)
            sender = msg.message.user.name
            robot.brain.data.players.remove(sender)
          else
            sender = commandData
            robot.brain.data.players.remove(sender)

          msg.send "#{emoticon} #{sender} is a chicken. #{maxplayers - robot.brain.data.players.length} more needed"
        when "add"
          players = [];
          commandData = msg.match[2].substring(msg.match[2].indexOf(' ') + 1)
          if (commandData.indexOf('random') != -1)
            playerData = if commandData.indexOf(' ') is -1 then null else commandData.substring(commandData.indexOf(' ') + 1)
            if(!playerData)
              return
            players.push playerData.split(',').shuffle()[0].trim()
          else
            players = commandData.split(",")

          robot.brain.data.players.push player.trim() for player in players

          robot.brain.data.shuffleCopy = []

          if (playersAreReady(robot.brain.data.players))
            startGame(msg, robot)
          else
            msg.send "#{emoticon} #{robot.brain.data.players.join(', ')} wants to play. #{maxplayers - robot.brain.data.players.length} more needed"
        when "rank"
          score = parseFloat(msg.match[2].split(" ")[1])
          if score
            robot.brain.data.rankings[sender] = score
          else
            if robot.brain.data.rankings[sender]
              score = robot.brain.data.rankings[sender]
            else
              score = robot.brain.data.rankings[sender] = 0
          rank = findRank(sender, robot)
          msg.send "#{emoticon} #{sender} is now ranked ##{rank} of #{Object.keys(robot.brain.data.rankings).length} with a score of #{score}"
        when "stats"
          statistic = robot.brain.data.playerStatistics[sender] ? {}
          matches = statistic.matches ? 0
          msg.reply "You have played #{matches} match#{['es' if matches == 0 || matches > 1 ]}"
        when "clear"
          numberOfPlayers = robot.brain.data.players.length;
          if(numberOfPlayers == 0)
            msg.send "No players in queue."
          else
            msg.send "Player queue is cleared. #{robot.brain.data.players.join(', ')} #{[if numberOfPlayers > 1 then 'are' else 'is' ]} removed from queue."
          robot.brain.data.players = []
        when "shuffle", "unfair", "not fair"
          shuffleLength = robot.brain.data.shuffleCopy.length;
          if (shuffleLength == 4)
            msg.send "Shuffling players..."
            shufflePlayers(msg, robot)
          else
            msg.send "Need 4 players to shuffle!"
        else
          msg.send "#{command} is an unknown command"
