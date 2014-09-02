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
     msg.http('http://ajax.googleapis.com/ajax/services/search/images')
     .query(q: menu.split(/\s+/).slice(0, 2).join(" "), v: '1.0')
     .get() (err, res, body) ->
      images = JSON.parse(body).responseData?.results
      if images?.length > 0
       msg.send images[0].unescapedUrl
    else
     msg.send "Couldn't find the menu for date " + getDate()

getDate = () ->
 currentDate = new Date()
 day = currentDate.getDate()
 month = currentDate.getMonth() + 1
 year = currentDate.getFullYear()
 return day + "/" + month + "/" + year
