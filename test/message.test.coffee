request = require('supertest')
app = require '../libs/app'
should = require 'should'
_ = require 'lodash'


describe("消息相关", () ->





  postData = {
    name: "messageTest"
    username: "messageTest"
    password: "messageTest"
    avatar_uri: 'http://ww3.sinaimg.cn/mw690/71ae9b51gw1f34ggm06a9j20cs0cs74t.jpg'
  }
  userId = ""
  it("用户注册",(done) ->
    request(app)
    .post('/users/register')
    .send(postData)
    .expect(200)
    .expect((result) ->
      userId = result.body.id
    )
    .end(done)
  )

  token = ""
  it("用户登录", (done) ->
    request(app)
    .post('/users/login')
    .send(postData)
    .expect(200)
    .expect((result) ->
      token = result.body.token
      console.log(token)
    )
    .end(done)
  )



  messageData = {
    content: '东区食堂1号窗口的大叔态度太差了'
  }
  it("发布一条消息",(done) ->
    request(app)
    .post('/messages')
    .set('x-token',token)
    .send(messageData)
    .expect(200)
    .expect((result) ->
      console.log(result.data)
    )
    .end(done)
  )
  it("发布一条消息",(done) ->
    request(app)
    .post('/messages')
    .set('x-token', token)
    .send(messageData)
    .expect(200)
    .expect((result) ->
    )
    .end(done)
  )

  it("获取所有消息",(done) ->
    request(app)
    .get('/messages')
    .expect(200)
    .expect((result) ->
      console.log(result.body)
    )
    .end(done)
  )



)