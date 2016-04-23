request = require('supertest')
app = require '../libs/app'
should = require 'should'
_ = require 'lodash'

describe('订单相关', ->

  postData = {
    name: "手撕包菜"
    price: 100
    discount: 0.9
    is_recommended: true
    is_hot: true
    is_breakfast: true
    is_lunch: true
    is_dinner: true
    address: "东区食堂"
    pic_url:'http://ww3.sinaimg.cn/mw690/71ae9b51gw1f34ggm06a9j20cs0cs74t.jpg'
    like: 0
  }

  foodId = null
  it('添加一个菜品', (done) ->
    request(app)
    .post("/foods")
    .send(postData)
    .expect(200)
    .expect((result) ->
      foodId = result.body._id
      console.log(result.body)
    )
    .end(done)
  )


  userData = {
    name: "tom"
    username: "tom"
    password: "tom"
  }
  user = ""
  it("用户注册",(done) ->
    request(app)
    .post('/users/register')
    .send(userData)
    .expect(200)
    .end(done)
  )
  token = ""
  it("用户登录", (done) ->
    request(app)
    .post('/users/login')
    .send(userData)
    .expect(200)
    .expect((result) ->
      user = result.body
      token = result.body.token
      console.log(token)
    )
    .end(done)
  )


  it("添加一个订单", (done) ->
    request(app)
    .post('/orders/' + foodId)
    .set('x-token',token)
    .expect(200)
    .expect((result) ->
      console.log(result.body)
    )
    .end(done)
  )
  it("再次添加一个订单", (done) ->
    request(app)
    .post('/orders/' + foodId)
    .set('x-token',token)
    .expect(200)
    .expect((result) ->
      console.log(result.body)
    )
    .end(done)
  )

  it("获得某用户所有订单",(done) ->
    request(app)
    .get('/orders/' + user._id)
    .expect(200)
    .expect((result) ->
      console.log(result.body)
    )
    .end(done)
  )
)