express = require('express')
router = express.Router()

foodBiz = require './../bizs/foodBiz'
commonBiz = require './../bizs/commonBiz'
uploadBiz = require './../bizs/uploadBiz'



# 上传一个菜品
router.post(
  ''
  foodBiz.publishFood
)


# 更新一个菜品
router.put(
  '/:foodId'
  foodBiz.updateFood
)

# 获取单个菜品详情
router.get(
  '/:foodId'
  foodBiz.getFood
)

router.get(
  ''
  foodBiz.getFoods
)

router.get(
  '/:foodId/like'
  foodBiz.likeFood
)


# 删除一个菜品
router.delete(
  "/:foodId"
  foodBiz.deleteFood
)

router.post(
  "/:id/upload"
  uploadBiz.uploadFoodIcon
)

module.exports = router