jwt = require('jsonwebtoken')

db = require('./../libs/db')

config = require('./../config/config')

md5Util = require('./../utils/md5Util')
Utils = require './../utils/Utils'

commonBiz = require './commonBiz'
_ = require('underscore')




makeOneOrder = (req,res,next) ->
  console.log('=====================')
  user = req.userInfo
  foodId = req.params['foodId']
  db.foods.findOne({_id: foodId},(err,food) ->
    return next(err) if err
    return next(commonBiz.customError(404,"该食物不存在,请检查您的食物id")) if not food
    db.orders.insert({user: user, food: food}, (err,order) ->

      return next(err) if err
      return next(commonBiz.customError(400,"添加订单失败")) if not order
      return res.json(order)
    )
  )




getOrdersByUserId = (req,res,next) ->
  userId = req.params['userId']
  db.orders.find({'user._id': userId}, (err,list) ->
    return next(err) if err
    return res.json(list)
  )

module.exports = {
  makeOneOrder: makeOneOrder
  getOrdersByUserId: getOrdersByUserId
}