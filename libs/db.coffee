Datastore = require('nedb')

config = require './../config/config'

db = {}
db.path = config.dbFilePath
db.users = new Datastore({ filename: db.path + 'users.db', autoload: true });
db.foods = new Datastore({ filename: db.path + 'foods.db', autoload: true });
db.orders = new Datastore({ filename: db.path + 'orders.db', autoload: true });
db.messages = new Datastore({ filename: db.path + 'messages.db', autoload: true });

module.exports = db