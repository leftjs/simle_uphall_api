path = require('path')

port = 7410
host = 'http://localhost:'
env = process.env.NODE_ENV
if env is 'production'
#  port = 7410
  host = 'http://121.42.182.77:'

module.exports = {
  port : port
  dbFilePath: path.join(__dirname,'./../database/')
  dbPath: 'mongodb://localhost/myapi'
  secret: 'token_secret'
  tokenExpiredTime: 1000*60*60*24*7

  avatar_base: host + port + '/images/avatar/'
  window_icon_base: host + port + '/images/window_icon/'
  comment_images_base: host  + port + '/images/comment_images/'
  food_icon_base: host + port + '/images/food_icon/'
}