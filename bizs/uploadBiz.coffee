
db = require('./../libs/db')
fs = require('fs')

config = require('./../config/config')

md5Util = require('./../utils/md5Util')
Utils = require './../utils/Utils'

commonBiz = require './commonBiz'
formidable = require 'formidable'
path = require('path')

eventproxy = require('eventproxy')

_ = require('underscore')

uploadAvatar = (req,res,next) ->

  userId = req.params['id']
  form = new formidable.IncomingForm()
  form.uploadDir = 'dist/images/avatar/'
  form.keepExtensions = true
  form.encoding = 'utf-8'
  # 头像的最大尺寸为10M
  form.maxFieldsSize = 1024 * 1024 * 10

  form.parse(req,(err,fields,files) ->
    return next(err) if err

    ep = new eventproxy()
    ep.fail((err) ->
      return next(err)
    )
    ep.after('done',_.keys(files).length,(datas) ->
#        console.log('12312312312312')
      res.json({msg: "上传成功"})
    )
    _.mapObject(files,(val,key) ->
      oldPath = val.path
      oldName = path.basename(oldPath)
      dirPath = path.dirname(oldPath)
      newName = oldName.substr(7,oldName.length)
      newPath = dirPath + '/' + newName

      fs.rename(oldPath,newPath,(err) ->
        return ep.emit('error',  ) if err
        #        return res.json(true)
        db.users.update({_id: userId},{$set:{avatar_uri:config.avatar_base + newName}}, (err,numReplaced)->
          return ep.emit('error', err) if err
          return ep.emit('error',commonBiz.customError(400,'上传失败,请重试')) if numReplaced is 0
          return ep.emit('done',null)
        )
      )
    )
  )





uploadFoodIcon = (req,res,next) ->

  foodId = req.params['id']

  db.foods.findOne({_id:foodId},(err,food) ->
    return next(err) if err
    return next(commonBiz.customError(404,'当前食物不存在')) if not food
    form = new formidable.IncomingForm()
    form.uploadDir = 'dist/images/food_icon/'
    form.keepExtensions = true
    form.encoding = 'utf-8'
    # 窗口icon的最大尺寸为10M
    form.maxFieldsSize = 1024 * 1024 * 10

    form.parse(req,(err,fields,files) ->
      return next(err) if err
      ep = new eventproxy()
      ep.fail((err) ->
        return next(err)
      )
      ep.after('done',_.keys(files).length,(datas) ->
        res.json({msg: "上传成功"})
      )
      _.mapObject(files,(val,key) ->
        oldPath = val.path
        oldName = path.basename(oldPath)
        dirPath = path.dirname(oldPath)
        newName = oldName.substr(7,oldName.length)
        newPath = dirPath + '/' + newName

        fs.rename(oldPath,newPath,(err) ->
          return ep.emit('error', err) if err
          #        return res.json(true)
          iconUri = config.food_icon_base + newName
          db.foods.update({_id: foodId},{$set:{pic_url:iconUri}}, (err,numReplaced)->
            return ep.emit('error',err) if err
            return ep.emit('error',commonBiz.customError(400,'上传失败,请重试')) if numReplaced is 0
            return ep.emit('done',null)
          )
        )
      )
    )
  )




# return res.json('hello')

module.exports = {
  uploadAvatar: uploadAvatar
  uploadFoodIcon:uploadFoodIcon
}



