var db = require('../utils/db');
var bkfd2Password = require('pbkdf2-password');
var hasher = bkfd2Password();
const nodemailer = require("nodemailer");

const { v4: uuidv4 } = require('uuid');
// const jwt = require('jsonwebtoken');

// 로그인 확인
exports.SignIn = async function(req) {
  var conn;
try{
  var json = {};
  json.code = 0;
  conn = await db.getConnection();
  console.log('login-service SignIn db getConnection');
  var userid = req.body.userid; //req.body.id -> req.body.userid
  var password = req.body.password;
  var query = "SELECT userid, userpw, salt, user_name, user_role FROM webdb.tb_user where userid='" + userid + "' ;";
  var rows = await conn.query(query); // 쿼리 실행
  if (rows[0]) {
      // 관리자만 접속 가능하도록 처리
      if(rows[0].user_role == 0) {
        json.code = 200;
        json.msg = "관리자만 접속 가능합니다.";
        json.data = {};
        console.log('login-service SignIn - 관리자만 접속 가능합니다.');
        return json;
      }
      //저장된 password 와 hash password 가 같은지를 체크하여 로그인 성공, 실패 처리 
      var userSalt = rows[0].salt;
      var userPass = rows[0].userpw;
      
      return new Promise((resolve, reject) => {
          hasher({
              password: password,
              salt: userSalt
          }, (err, pass, salt, hash) => {
              if (hash != userPass) {
                json.code = 200;
                json.msg = "패스워드가 일치하지 않습니다.";
                console.log(userPass)
                console.log(hash)
                json.data = {};
              } else {
                // console.log('login-service json.code', json.code);
                json.data = rows[0];
              }
              resolve(json);
          });
      });
  } else {
      json.code = 300;
      json.msg = "존재하지 않는 ID입니다.";
      json.data = {};
      return json;
  }
} catch(error) {
  console.log('login-service SignIn:'+error);
} finally {
  if (conn) conn.end();
}

};



// 회원가입
exports.signUp = async function(req, res) {
  var conn;
  var resultcode = 0;
  try{
    var json = {};
    json.code = 0;
    conn = await db.getConnection();
    // console.log('login-service SignUp db getConnection')
    var { userid, password, password2, name } = req.body;
    var fig = 0;
    var query = "SELECT userid FROM webdb.tb_user where userid='" + userid + "' ;";
    var rows = await conn.query(query); // 쿼리 실행
    if(name=='' || req.body.user_email=='' || req.body.password=='' || req.body.password2=='') {
      json.code = 200;
      console.log('dataif-service update: empty data');
      return json;
    }
    if(password != password2) {
        // 비밀번호가 일치하지 않음
        json.code = 200;
        json.msg = "비밀번호가 일치하지 않습니다.";
        console.log('비밀번호가 일치하지 않습니다.');
        return json;
    }
    if (rows[0] == undefined) {
        hasher({
            password: password
        }, async (err, pass, salt, hash) => {
          const uidUser = uuidv4();
          var query = "INSERT INTO webdb.tb_user (uid, userid, userpw, user_name, salt, user_role, user_email, user_type, youthAge_code, parentsAge_code, emd_class_code, sex_class_code, fig) values ('"+uidUser+"', '"+req.body.userid+"','"+hash+"','"+req.body.user_name+"', '"+salt+"', '"+req.body.user_role+"', '"+req.body.user_email+"', '"+req.body.user_type+"', '"+req.body.youthAge_code+"','"+req.body.parentsAge_code+"', '"+req.body.emd_class_code+"', '"+req.body.sex_class_code+"', '"+fig+"')";
          var rows = await conn.query(query); // 쿼리 실행
          console.log('회원 등록에 성공했습니다.');
          json.code = 0;
          json.msg = "회원 등록에 성공했습니다.";
          return json;
        });
    } else {
        // 이미 있음
        console.log('이미 존재하는 아이디입니다.');
        json.code = 100;
        json.msg = "이미 존재하는 아이디입니다.";
        return json;
    }
    return json;
  } catch(error) {
    console.log('login-service SignUp:'+error);
    json.code = 200;
    json.msg = "회원가입 실패";
    return json;
  } finally {
    if (conn) conn.end();
  }
};


// 세션의 유저아이디를 통해 출석기록 받아오기
exports.getAttendance = async function(req, res) {
  var resultcode = 0;
  var conn;
  try{
    conn = await db.getConnection();
    var userid = req.session.user.data.userid;
    var query = 'SELECT uid FROM webdb.tb_user where userid="'+userid+'"';
    var uid = await conn.query(query); // 쿼리 실행
    
    // uid를 통해 출석기록 받아오기
    var query = 'SELECT * FROM webdb.tb_attendance_logs where user_uid="'+uid[0].uid+'"';
    var attendanceLog = await conn.query(query); // 쿼리 실행
    if(attendanceLog.length){
      resultcode = 1;
    } else resultcode = 0;
    return attendanceLog;
  } catch(error) {
    console.log('login-service getAttendance:'+error);
  } finally {
    if (conn) conn.end();
  }
  return resultcode;
};

exports.checkAttendance = async function(req, res) {
  var resultcode = 0;
  var conn;
  try{
    conn = await db.getConnection();
    var userid = req.session.user.data.userid;
    // userid를 통해 uid받아오기
    var query = 'SELECT uid FROM webdb.tb_user where userid="'+userid+'"';
    var uid = await conn.query(query); // 쿼리 실행'
    query = 'insert into webdb.tb_attendance_logs (user_uid) values ("'+uid[0].uid+'")';
    var rows = await conn.query(query); // 쿼리 실행
    resultcode = 1;
  } catch(error) {
    console.log('login-service checkAttendance:'+error);
  } finally {
    if (conn) conn.end();
  }
  return resultcode;
};