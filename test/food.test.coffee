request = require('supertest')
app = require '../libs/app'
should = require 'should'
_ = require 'lodash'

describe('菜品相关', ->

  postData = {
    name: "老坛酸菜"
    price: 100
    discount: 0.9
    is_recommended: true
    is_hot: true
    is_breakfast: true
    is_lunch: true
    is_dinner: true
    address: "东区食堂"
    pic_url:''
    like: 0
    description: "位于食堂的美食,永远有让人回味无穷的感觉"
    orderCount: 0
    start_time: "12:00"
    end_time: "12:00"
  }

  foodId = null
  it('添加一个菜品', (done) ->
    request(app)
    .post("/foods")
    .send(postData)
    .expect(200)
    .expect((result) ->
      foodId = result.body._id
    )
    .end(done)
  )

  updatePostData = _.merge(postData, {
    address: "西区食堂"
  })

  it('更新一个菜品',(done) ->
    request(app)
    .put('/foods/' + foodId)
    .send(updatePostData)
    .expect(200)
    .end(done)
  )

  it('获取一个菜品', (done) ->
    request(app)
    .get('/foods/' + foodId)
    .expect(200)
    .end(done)
  )


  it("删除一个菜品", (done) ->
    request(app)
    .delete('/foods/' + foodId)
    .expect(200)
    .end(done)
  )


  it('添加一个菜品', (done) ->
    request(app)
    .post("/foods")
    .send(postData)
    .expect(200)
    .expect((result) ->
      foodId = result.body._id
    )
    .end(done)
  )


  it('上传菜品图片', (done) ->
    request(app)
    .post('/foods/' + foodId + '/upload')
    .attach('icon', 'dist/images/food_icon/dog.jpg')
    .expect(200)
    .expect((result) ->
      console.log(result.body)
    )
    .end(done)
  )

  it("喜欢一个菜品", (done) ->
    request(app)
    .get('/foods/' + foodId + '/like')
    .expect(200)
    .end(done)
  )
  it('获取一个菜品', (done) ->
    request(app)
    .get('/foods/' + foodId)
    .expect(200)
    .expect((result) ->
      console.log(result.body)
    )
    .end(done)
  )
)