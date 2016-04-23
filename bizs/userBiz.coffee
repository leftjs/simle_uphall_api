jwt = require('jsonwebtoken')

db = require('./../libs/db')

config = require('./../config/config')

md5Util = require('./../utils/md5Util')
Utils = require './../utils/Utils'

commonBiz = require './commonBiz'
_ = require('underscore')


# 验证用户是否存在
validateUserExist = (req,res,next) ->
#  console.log(req.body)
  body = req.body
  return next(commonBiz.customError(400,'请提交完整的用户注册信息')) if not body or not body.username or not body.password
  db.users.findOne({username: req.body.username},(err,user) ->
    return next(err) if err
    return next(commonBiz.customError(400,'用户已注册，无法再次注册')) if user
    next()
  )



# 注册
register = (req,res,next) ->
  body = req.body
  postData = {
    name: if body.name? then body.name else "匿名"
    username: body.username
    password: md5Util.md5(body.password)
    token: ''
    expiredTime: Date.now()
    avatar_uri: if body.avatar_uri? then body.avatar_uri else ''
  }

  db.users.insert(postData,(err,user) ->
    return next(err) if err
    #    console.log(user)
    res.send({id: user._id})
  )


# 登录
login = (req,res,next) ->
  username = req.body.username
  password = md5Util.md5(req.body.password ?= '')
  db.users.findOne({username:username,password:password},(err,user) ->
    return next(err) if err
    return next(commonBiz.customError(400,'用户名或密码错误')) if not user
    token = jwt.sign({id: user._id},config.secret)
    expiredTime = Date.now() + config.tokenExpiredTime
    db.users.update({_id:user._id},{$set: {token:token,expiredTime:expiredTime}},(err,numReplaced) ->
      return next(err) if err
      return next(commonBiz.customError(400,'登录失败，请重试')) if numReplaced is 0
      db.users.findOne({_id: user._id}, (err,user) ->
        return next(err) if err
        return res.json(user)
      )
    )
  )


getUser = (req,res,next) ->
  db.users.findOne({_id: req.params['id']},(err,user) ->
    return next(err) if err
    return next(commonBiz.customError(404,'未找到该用户')) if not user
    allowToShow = ['name','avatar_uri']
    for field in _.difference(_.keys(user),allowToShow)
      delete  user[field]
    return res.json({user: user})
  )


module.exports = {
  validateUserExist: validateUserExist
  register: register
  login: login
  getUser: getUser
}