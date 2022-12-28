var db = require('../utils/db');
var bkfd2Password = require('pbkdf2-password');
var hasher = bkfd2Password();
const jwt = require('jsonwebtoken');


//임시로 사용
const mysql = require('mysql');
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PSWORD,
  database: process.env.DB_DATABASE,
  connectionLimit: 5
});

exports.SignIn = async function(req) {
  var conn;
try{
  var json = {};
  json.code = 0;
  var userid = req.body.userid;
  var password = req.body.password;
  var query = "SELECT userid, password, salt, name FROM webdb.tb_user where userid='" + userid + "' ;";
  pool.query(query, function(err, results, fields) {
    if (err) {
      console.log(err);
    }
    console.log(results);
  });
  pool.query(query, function (err, rows) {
      if (err) {
          console.log('login-service SignIn:'+err);
          json.code = 100;
          json.msg = "로그인 실패";
          json.data = {};
          return json;
      }
      if (rows[0]) {
          var userSalt = rows[0].salt;
          var userPass = rows[0].password;
          hasher({
              password: password,
              salt: userSalt
          }, (err, pass, salt, hash) => {
              if (hash != userPass) {
                  json.code = 100;
                  json.msg = "패스워드 일치하지 않습니다.(운영환경 : ID 및 비밀번호가 일치하지 않습니다.)";
                  json.data = {};
              } else {
                  json.data = rows[0];
              }
              console.log(json.code);
              return json;
          });
      } else {
          json.code = 100;
          json.msg = "존재하지 않는 ID 입니다.(운영환경 : ID 및 비밀번호가 일치하지 않습니다.)";
          json.data = {};
          return json;
      }
  });
} catch(error) {
  console.log('login-service SignIn:'+error);
  json.code = 100;
  json.msg = "로그인 실패";
  json.data = {};
  return json;
} finally {
  if(db) db.end(
    function(err) {
      if (err) {
        console.log(err);
      }
    }
  );}
};

// user 중복 체크
const u = (user) => new Promise((resolve, reject) => {
  const query = "SELECT userid, password, name, salt FROM webdb.tb_user where userid='" + user.userid + "';";
  pool.query(query, function(err, results, fields) {
    var resultcode = 0;
    if(err) {
      reject(err);
    }
    if(results.length > 0) {//중복이 있을 경우
      resultcode = 100;
      //return resultcode;
    }
    resolve(resultcode);
  });
});
// 회원가입
exports.signUp = async function(req, res) {
  var resultcode = 0;
  var conn;
  try{
    //console.log(req.body);
    resultcode = await u(req.body);
    // 중복 체크
    if(resultcode == 100) {
      console.log('login-service SignUp:중복');
      return resultcode;
    }
    //비밀번호 확인 불일치
    if(req.body.password != req.body.password2) {
      console.log('login-service SignUp:비밀번호 불일치');
      resultcode = 100;
      return resultcode;
    }
    
  console.log('login-service SignUp:중복아님');

      hasher({password:req.body.password}, function(err, pass, salt, hash) {
        const query = " insert into webdb.tb_user (userid, password, name, salt, user_role, user_email, age_class_code, emd_class_code,sex_class_code) values ('"+req.body.userid+"','"+hash+"','"+req.body.name+"', '"+salt+"', '"+req.body.user_role+"', '"+req.body.user_email+"', '"+req.body.age_class_code+"', '"+req.body.emd_class_code+"', '"+req.body.sex_class_code+"')";
        pool.query(query, function(err, rows, fields) {
          if(err) {
            console.log(err);
          }
        });
      });
  } catch(error) {
    console.log('login-service SignUp:'+error);
    resultcode = 100;
  } finally {
    if(db) db.end(
      function(err) {
        if (err) {
          console.log(err);
        }
      }
    );
  }
  return resultcode;
};

//로그인 체크
exports.login_check = async function(req, res) {
  var resultcode = 0;
  var conn;
  try{
    conn = await db.getConnection();
    var userid = req.body.userid;
    var password = req.body.password;
    var name = req.body.name;
    var query = 'SELECT password, salt FROM webdb.tb_user where userid="'+userid+'"';
    var rows = await conn.query(query); // 쿼리 실행
    if(rows.length){
      var user = rows[0];
      return new Promise((resolve,reject)=>{
          hasher( 
            { password: password, salt: user.salt },
            function (err, pass, salt, hash) {
              if (hash === user.password) resultcode = 3;
              else resultcode = 2;
              resolve(resultcode);
          });
      });
    } else resultcode = 1;

    return resultcode;
  } catch(error) {
    console.log('login-service login_check:'+error);
  } finally {
    if (conn) conn.end();
  }
};

exports.date_check = async function(req, res) {
  var resultcode = 0;
  var conn;
  try{
    conn = await db.getConnection();
    var userid = req.user.userid;
    var query = "SELECT case when Timestampdiff(hour, Date_format(Str_to_date(a.strt_date, '%Y%m%d'),'%Y-%m-%d'),now()) >= 0 and Timestampdiff(hour, Date_format(Str_to_date(a.end_date, '%Y%m%d'),'%Y-%m-%d'),now()) <= 0 then "
      +"Timestampdiff(hour, now(), Date_format(Str_to_date(a.end_date, '%Y%m%d'),'%Y-%m-%d')) else 0 end expr"
//      +"when Timestampdiff(hour, Date_format(Str_to_date(a.strt_date, '%Y%m%d'),'%Y-%m-%d'),now()) < 0 and Timestampdiff(hour, Date_format(Str_to_date(a.end_date, '%Y%m%d'),'%Y-%m-%d'),now()) <= 0 then "
//      +"Timestampdiff(hour, now(),Date_format(Str_to_date(a.end_date, '%Y%m%d'),'%Y-%m-%d')) else 0 end expr"
      +", a.strt_date FROM webdb.tb_dataif a inner join webdb.tb_sensor b on a.sensor_board_idx=b.board_idx inner join webdb.tb_device c on b.dev_board_idx=c.board_idx where a.permit_type in ('Y', 'S') and a.ins_id='"+userid+"' and b.sen_mng_no='"+req.body.sensorid+"'";
    var rows = await conn.query(query); // 쿼리 실행
    var expr=0;
    if(rows.length>0) {
      expr=rows[0].expr;
      const token = jwt.sign(
        { userid: userid },
        'eyJ1c2VySWQiOiIxIiwiaWF0IjoxNjMyOTg2',
        { expiresIn: expr });
      if(expr>0) req.user.token=token;
      //req.user.strt_date=rows[0].strt_date;
    }

    return resultcode;
  } catch(error) {
    console.log('login-service date_check:'+error);
  } finally {
    if (conn) conn.end();
  }
};
