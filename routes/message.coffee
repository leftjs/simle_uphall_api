express = require('express')
router = express.Router()

commonBiz = require './../bizs/commonBiz'
messageBiz = require './../bizs/messageBiz'



# 发布一条消息
router.post(
  '',
  commonBiz.authAndSetUserInfo
  messageBiz.publishMessage
)



# 获取所有的消息列表
router.get(
  '',
  messageBiz.getMessages
)
module.exports = router