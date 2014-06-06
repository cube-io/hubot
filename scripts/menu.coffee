# Description:
#   Gets the menu of the day
#
# Commands:
#   hubot menu

module.exports = (robot) ->
 robot.respond /menu$/i, (msg) ->
  msg.http("https://gist.githubusercontent.com/Leh2/9f500c3f2290fcc269c5/raw/")
   .get() (error, response, body) ->
    menu = JSON.parse(body)[getDate()]
    if menu?
     msg.send "(chompy) " + menu
    else
     msg.send "Couldn't find the menu for date " + getDate()

getDate = () ->
 currentDate = new Date()
 day = currentDate.getDate()
 month = currentDate.getMonth() + 1
 year = currentDate.getFullYear()
 return day + "/" + month + "/" + year
