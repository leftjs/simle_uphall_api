jwt = require('jsonwebtoken')

db = require('./../libs/db')

config = require('./../config/config')

md5Util = require('./../utils/md5Util')
Utils = require './../utils/Utils'

commonBiz = require './commonBiz'
_ = require('underscore')

moment = require 'moment'



# 生成一个订单
makeOneOrder = (req,res,next) ->
  user = req.userInfo
  foodId = req.params['foodId']
  orderTime = if req.body.orderTime then req.body.orderTime else '11:20'
  timeArr = orderTime.match(/(\d+)(-|:)(\d+)/)
  orderTime = moment().set({hour: timeArr[1], minute: timeArr[3]}).format()
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