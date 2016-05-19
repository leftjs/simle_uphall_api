jwt = require('jsonwebtoken')

db = require('./../libs/db')

config = require('./../config/config')

md5Util = require('./../utils/md5Util')
Utils = require './../utils/Utils'

commonBiz = require './commonBiz'
_ = require('underscore')

moment = require 'moment'




makeOneOrder = (req,res,next) ->
  console.log('=====================')
  user = req.userInfo
  foodId = req.params['foodId']
  orderTime = req.body.orderTime
  timeArr = orderTime.match(/(\d+)(-|:)(\d+)/)
  orderTime = moment().set({hour: timeArr[1], minute: timeArr[3]}).format()
#  var moment = require('moment')
#var timeArr = '22:10'.match(/(\d+)(-|:)(\d+)/)
#var time = moment().set({hour: timeArr[1], minute: timeArr[3]})
#console.log(time.format())

  db.foods.findOne({_id: foodId},(err,food) ->
    return next(err) if err
    return next(commonBiz.customError(404,"该食物不存在,请检查您的食物id")) if not food
    db.orders.insert({user: user, food: food, time: moment(new Date).format(), orderTime: orderTime }, (err,order) ->
      return next(err) if err
      return next(commonBiz.customError(400,"添加订单失败")) if not order

      db.foods.update({_id: foodId},{$inc: {orderCount: 1}},(err,numReplaced) ->
        return next(err) if err
        return next(commonBiz.customError(400,"添加订单失败")) if numReplaced is 0
        return res.json(order)
  )))






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