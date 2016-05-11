jwt = require('jsonwebtoken')

db = require('./../libs/db')

config = require('./../config/config')

moment = require 'moment'

md5Util = require('./../utils/md5Util')
Utils = require './../utils/Utils'

commonBiz = require './commonBiz'
_ = require('underscore')


buildFoodWithBody = (body) ->

  moment.locale('zh_cn')
  return postData = {
    name: if body.name? then body.name else "麻辣香锅"
    price: if body.price? then body.price else 10
    discount: if body.discount? then body.discount else 1
    is_recommended: if (body.is_recommended? && typeof body.is_recommended is 'boolean' && body.is_recommended is true) then true else false
    is_hot: if(body.is_hot? && typeof body.is_hot is "boolean" && body.is_hot is true) then true else false
    is_breakfast: if(body.is_breakfast? && typeof body.is_breakfast && body.is_breakfast is true) then true else false
    is_lunch: if(body.is_lunch? && typeof body.is_lunch && body.is_lunch is true) then true else false
    is_dinner: if(body.is_dinner? && typeof body.is_dinner && body.is_dinner is true) then true else false
    address: if body.address? then body.address else "食堂"
    pic_url: if body.pic_url? then body.pic_url else ""
    like: if body.like? then body.like else 0
    description: if body.description? then body.description else "位于食堂的美食,永远有让人回味无穷的感觉"
    orderCount: 0
    start_time: if body.start_time? then body.start_time else "12:00"
    end_time: if body.end_time? then body.end_time else "12:00"
  }


#  {
#    "name": "麻辣香锅",
#    "price": 10,
#    "discount": 0.4,
#    "is_recommended": true,
#    "is_hot": true,
#    "is_breakfast": true,
#    "is_lunch": true,
#    "is_dinner": true,
#    "address": "食堂三楼",
#    "start_time": "2012-12-12 12:33",
#    "end_time": "2012-12-12 12:33"
#  }

publishFood = (req,res,next) ->
  body = req.body
  postData = buildFoodWithBody(body)
  db.foods.insert(postData,(err,food) ->
    return next(err) if err
    res.json(food)
  )


updateFood = (req,res,next) ->
  body = req.body
  postData = buildFoodWithBody(body)
  foodId = req.params["foodId"]

  db.foods.findOne({_id: foodId}, (err,food) ->
    return next(err) if err
    return next(commonBiz.customError(404, "所需更改的菜品不存在")) if not food
    db.foods.update({_id: food._id}, {$set: postData},(err,numReplaced) ->
      return next(err) if err
      return next(commonBiz.customError(400, "更新失败")) if numReplaced is 0
      res.json({msg: "更新成功"})

    )
  )


getFood = (req,res,next) ->
  foodId = req.params["foodId"]
  db.foods.findOne({_id: foodId},(err,food) ->
    return next(err) if err
    return next(commonBiz.customError(404, '该菜品没有找到')) if not food
    res.json(food)
  )

getFoods = (req,res,next) ->
  db.foods.find({}, (err,list) ->
    return next(err) if err
    res.json(list)
  )


deleteFood = (req,res,next) ->
  db.foods.remove({_id: req.params["foodId"]},(err,numRemoved) ->
    return next(err) if err
    return next(commonBiz.customError(404, "该商品不存在")) if numRemoved is 0
    res.json({msg: "删除成功"})
  )


likeFood = (req,res,next) ->
  db.foods.update({_id: req.params['foodId']},{$inc: {like: 1}},(err,numReplaced) ->
    return next(err) if err
    return next(commonBiz.customError(400,"喜欢失败")) if numReplaced is 0
    res.json({msg: "喜欢成功"})
  )


module.exports = {
  publishFood: publishFood
  updateFood: updateFood
  getFood: getFood
  getFoods: getFoods
  deleteFood: deleteFood
  likeFood: likeFood
}