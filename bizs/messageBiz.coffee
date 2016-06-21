jwt = require('jsonwebtoken')

db = require('./../libs/db')

config = require('./../config/config')

md5Util = require('./../utils/md5Util')
Utils = require './../utils/Utils'

commonBiz = require './commonBiz'
_ = require('underscore')




publishMessage = (req,res,next) ->
  user = req.userInfo
  content = req.body.content

  db.messages.insert({
#    发布者
    user: user,
#    内容
    content: content,
#    创建时间
    create_at: Date.now()
  },(err,msg) ->
    return next(err) if err
    return next(commonBiz.customError(400,"消息发送失败")) if not msg
    return res.json(msg)
  )


getMessages = (req,res,next) ->
  db.messages.find({}).sort({create_at: -1}).exec((err,list) ->
    res.json({messages: list})
  )





module.exports = {
  publishMessage: publishMessage
  getMessages: getMessages
}