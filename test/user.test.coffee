request = require('supertest')
app = require '../libs/app'
should = require 'should'
_ = require 'lodash'


describe("用户相关", () ->

  postData = {
    name: "jason"
    username: "jason"
    password: "jason"
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
  it("用户重复注册",(done) ->
    request(app)
    .post('/users/register')
    .send(postData)
    .expect(400)
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




  it("获取指定用户信息", (done) ->
    request(app)
    .get('/users/' + userId)
    .expect(200)
    .expect((result) ->
      result.body.user.should.not.have.property('password')
    )
    .end(done)
  )

  it("上传头像", (done) ->
    request(app)
    .post('/users/' + userId + '/upload')
    .attach('icon', 'dist/images/avatar/dog.jpg','dog.jpg')
    .expect(200)
    .expect((res) ->
      console.log(res.body)
    )
    .end(done)
  )



)