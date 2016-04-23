express = require('express')
router = express.Router()

userBiz = require './../bizs/userBiz'
commonBiz = require './../bizs/commonBiz'
uploadBiz = require './../bizs/uploadBiz'


# 注册用户
router.post(
  '/register'
  userBiz.validateUserExist
  userBiz.register
)

# 用户登录
router.post(
  '/login'
  userBiz.login
)

# 获取用户信息
router.get(
  '/:id'
  userBiz.getUser
)

router.post(
  '/:id/upload'
  uploadBiz.uploadAvatar
)



module.exports = router