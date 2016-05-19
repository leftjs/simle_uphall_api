/**
 * Created by jason on 5/19/16.
 */
var moment = require('moment')
var timeArr = '22-10'.match(/(\d+)(-|:)(\d+)/)
var time = moment().set({hour: timeArr[1], minute: timeArr[3]})
console.log(time.format())