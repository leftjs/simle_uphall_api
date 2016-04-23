express = require('express')
router = express.Router()

commonBiz = require './../bizs/commonBiz'
uploadBiz = require './../bizs/uploadBiz'
orderBiz = require './../bizs/orderBiz'


router.post(
  '/:foodId'
  commonBiz.authAndSetUserInfo
  orderBiz.makeOneOrder
)


router.get(
  '/:userId'
  orderBiz.getOrdersByUserId
)

module.exports = router