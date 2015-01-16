# Description:
#   Gets the menu of the day
#
# Commands:
#   hubot menu
$ = require('jquery')(require("jsdom").jsdom().parentWindow)

module.exports = (robot) ->
 robot.respond /(menu|mad|food)$/i, (msg) ->
  msg.http("http://m.opino.dk/index.php/app/index/id/8")
   .get() (error, response, body) ->
    if(error)
      msg.send error
    else
      warmDish = $(body).find('a:contains("Varm ret med tilbehør")').parents('td').find('.app_dish').text()
      coldDish = $(body).find('a:contains("Pålæg")').parents('td').find('.app_dish').text()
      dessert = $(body).find('a:contains("Dessert")').parents('td').find('.app_dish').text()
      menu = warmDish + ' - ' + coldDish + (if dessert then ' - ' + dessert else '')
      msg.send ":fork_and_knife: " + menu

      msg.http('http://ajax.googleapis.com/ajax/services/search/images')
        .query(q: menu.split(/\s+/).slice(0, 3).join(" "), v: '1.0')
        .get() (err, res, body) ->
          images = JSON.parse(body).responseData?.results
          if images?.length > 0
            msg.send images[0].unescapedUrl

getDate = () ->
 currentDate = new Date()
 day = currentDate.getDate()
 month = currentDate.getMonth() + 1
 year = currentDate.getFullYear()
 return day + "/" + month + "/" + year
