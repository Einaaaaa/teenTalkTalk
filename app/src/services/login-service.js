var db = require('../utils/db');
var bkfd2Password = require('pbkdf2-password');
var hasher = bkfd2Password();
const nodemailer = require("nodemailer");

const { uuid } = require('uuidv4');
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
        json.code = 100;
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
  var resultcode = 0;
  var conn;
  try{
    conn = await db.getConnection();
    // console.log('login-service SignUp db getConnection')
    var { userid, password, password2, name, invite_code: inviteCode } = req.body;
    var fig = 0;
    var query = "SELECT userid FROM webdb.tb_user where userid='" + userid + "' ;";
    var rows = await conn.query(query); // 쿼리 실행
    if(name=='' || req.body.email=='' || req.body.password=='' || req.body.password2=='') {
      resultcode=100;
      console.log('dataif-service update: empty data');
      return resultcode;
    }
    if(password != password2) {
        // 비밀번호가 일치하지 않음
        console.log('비밀번호가 일치하지 않습니다.');
        resultcode = 100;
        return resultcode;
    }
    query = "SELECT eid, fig_payment FROM webdb.tb_event WHERE eid = 2 OR eid = 6 OR eid = 7;"; // 무화과 지급량 받아오기
    var figPayment = await conn.query(query); // 쿼리 실행
    welcomeTalk = figPayment[0].fig_payment;
    inviteFriend = figPayment[1].fig_payment;
    recommender = figPayment[2].fig_payment; // 추천인 무화과 지급량 설정
    if (rows[0] == undefined) {
      // invite코드의 유저에 무화과 추가
      if(inviteCode != '') {
        query = "SELECT fig,uid FROM webdb.tb_user where userid='" + inviteCode + "' ;";
        var inv = await conn.query(query); // 쿼리 실행
        if(inv[0] == undefined) {
          console.log('존재하지 않는 코드입니다.');
          resultcode = 100;
          return resultcode;
        }
        // int형식으로 무화과 추가후 varchar로 변환
        inv[0].fig = parseInt(inv[0].fig) + 1;
        inv[0].fig = inv[0].fig.toString();
        query = "UPDATE webdb.tb_user SET fig='"+inv[0].fig+"' WHERE userid='"+inviteCode+"';";
        var figUpdate = await conn.query(query); // 쿼리 실행
        var eid = 1; // TODO:무화과 이벤트 번호, 바꿔야함
        query = "insert into webdb.tb_event_part(eid,uid) values('"+eid+"','"+inv[0].uid+"');";
        // console.log(query);
        var eventPart = await conn.query(query); // 쿼리 실행
        fig+=1; //TODO: 지급 무화과 수 변경 필요
        fig = fig.toString();
      }
        hasher({
            password: password
        }, async (err, pass, salt, hash) => {
          const uidUser = uuid();
          var query = "INSERT INTO webdb.tb_user (uid, userid, userpw, user_name, salt, user_role, user_email, user_type, youthAge_code, parentsAge_code, emd_class_code, sex_class_code, fig) values ('"+uidUser+"', '"+req.body.userid+"','"+hash+"','"+req.body.name+"', '"+salt+"', '"+req.body.user_role+"', '"+req.body.user_email+"', '"+req.body.user_type+"', '"+req.body.youthAge_code+"','"+req.body.parentsAge_code+"', '"+req.body.emd_class_code+"', '"+req.body.sex_class_code+"', '"+fig+"')";
          var rows = await conn.query(query); // 쿼리 실행
          console.log('회원가입 성공');
        });
    } else {
        // 이미 있음
        console.log('이미 존재하는 아이디입니다.');
        resultcode = 100;
    }
  } catch(error) {
    console.log('login-service SignUp:'+error);
  } finally {
    if (conn) conn.end();
  }
  
  return resultcode;
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