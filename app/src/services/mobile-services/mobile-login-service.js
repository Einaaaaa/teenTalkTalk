var db = require('../../utils/db');
var bkfd2Password = require('pbkdf2-password');
var bcrypt = require('bcrypt');
var RowDataPacket = require('mariadb');
const generateJsonWebToken = require('../../lib/generate_jwt');
var hasher = bkfd2Password();
const { v4: uuidv4 } = require('uuid');

// const jwt = require('jsonwebtoken');


// 모바일 로그인
exports.SignIn = async function(req) {
  var conn;
try{
  var json = {};
  json.code = 0;
  // console.log('mobile-login-service : ', req.body);
  const id = req.body['userid'];
  const password = req.body['userpw'];
  // console.log(id, password);

  conn = await db.getConnection();
  // console.log('login-service SignIn db getConnection');
  
  // 사용자 정보(아이디, 비밀번호, salt)
  const userdb = await conn.query("SELECT uid, userid, userpw, salt FROM webdb.tb_user WHERE userid= ?;", [id]);
  // console.log(userdb[0]);

  if (userdb && userdb[0]){
    var userPass = userdb[0].userpw;
    var userSalt = userdb[0].salt;
    // const passwordMatch = await bcrypt.compareSync(password, userPass);
    const result = await new Promise((resolve, reject) => {
      hasher({
        password: password,
        salt: userSalt
      }, (err, pass, salt, hash) => {
        if (hash !== userPass) {
          json.code = 100;
          json.msg = "패스워드 일치하지 않습니다.";
          json.data = {};
          resolve(json);
        } else {
          json.data = userdb[0];
          // console.log('login-service json.data', json.data);
          resolve(json);
        }
      });
    });
  
    return result;

  } else {
    json.code = 200;
    json.msg = "ID 일치하지 않습니다.";
    json.data = {};
    return json;
}
 
} catch(error) {
  console.log('mobile-login-service SignIn:'+error);
} finally {
  if (conn) conn.release();
}

};

// 카카오 로그인
exports.KakaoSignIn = async function(req) {
  var conn;
  try {
    var json = {};
    json.code = 0;
    const id = req.body.userid;
    const user_email = req.body.user_email;
    // console.log(id, user_email);
    conn = await db.getConnection();
    // console.log('login-service KakaoSignIn db getConnection');
  
    // 사용자 정보(아이디, 이메일)
    const userdb = await conn.query("SELECT uid, userid, user_email FROM webdb.tb_user WHERE userid = ? AND user_email = ?;", [id, user_email]);
    if (userdb && userdb[0]) {
      json.data = userdb[0];
      return json;
    } else {
      json.code = 200;
      json.msg = "일치하는 사용자 정보를 찾을 수 없습니다.";
      json.data = {};
      return json;
    }
  } catch(error) {
    console.log('mobile-login-service KakaoSignIn:', error);
  } finally {
    if (conn) conn.release();
  }
};




  // 카카오 가입
  exports.KakaoSignUp = async function(req) {
    var resultcode = 0;
    var conn;
    try{
      conn = await db.getConnection();
      console.log('mobile-login-service kakao login');
      
      console.log(req.body);
      const {userid,user_name, user_email, user_role, user_type, invite_code, youthAge_code, parentsAge_code, emd_class_code, sex_class_code} = req.body;
    
    // uid 생성 및 중복 체크
    do {
      var uid = uuidv4();
      var uidPrefix = uid.slice(0,8); // 앞 8자리 중복 체크 (초대코드로 사용 예정)
      var countQuery = "SELECT COUNT(*) AS count FROM webdb.tb_user WHERE uid LIKE '" + uidPrefix + "%';";
      var countResult = await conn.query(countQuery);
      var count = countResult[0].count;
      // console.log(count);
    } while (count > 0);

      query = "SELECT COUNT(*) AS count FROM webdb.tb_user WHERE userid='" + userid + "' ;";
      var userExists = await conn.query(query); // 쿼리 실행

      if (userExists[0].count > 0) {
        console.log('해당 계정으로 가입된 아이디가 이미 존재합니다.');
        resultcode = 100;
        return resultcode;
      } else {
        var pass = '';
        var salt = '';
        var randomNumber = Math.floor(10000 + Math.random() * 90000); // token_temp
        var uid = uuidv4(); // 고유 식별 번호
        // console.log(uid);
        await conn.query(`CALL webdb.SP_REGISTER_USER(?,?,?,?,?,?,?,?,?,?,?,?,?);`, [uid, userid, pass, salt, user_name, user_email, user_role, user_type, youthAge_code, parentsAge_code, sex_class_code, emd_class_code, randomNumber ]);
      }

    
      
    } catch(error) {
      console.log('mobile-login-service SignUp:'+error);
    } finally {
      if (conn) conn.release();
    }
    
    return resultcode;
  
  };


// 모바일 로컬 회원가입
exports.signUp = async function(req, res) {
  var resultcode = 0;
  var conn;
  try{
    conn = await db.getConnection();
    console.log('mobile-login-service signUp');
    
    console.log(req.body);
    const {userid,user_name, user_email, userpw, userpw2, user_role, user_type, invite_code, youthAge_code, parentsAge_code, emd_class_code, sex_class_code} = req.body;
    var query = "SELECT userid FROM webdb.tb_user where userid='" + userid + "' ;";
    var rows = await conn.query(query); // 쿼리 실행

    // uid 생성 및 중복 체크
    do {
      var uid = uuidv4();
      var uidPrefix = uid.slice(0,8); // 앞 8자리 중복 체크 (초대코드로 사용 예정)
      var countQuery = "SELECT COUNT(*) AS count FROM webdb.tb_user WHERE uid LIKE '" + uidPrefix + "%';";
      var countResult = await conn.query(countQuery);
      var count = countResult[0].count;
      // console.log(count);
    } while (count > 0);
    // console.log(uid);
    
    if(user_name=='' || user_email=='' || userpw=='' || userpw2=='') {
      resultcode=100;
      console.log('필수 정보를 입력해주세요.');
      return resultcode;
    }
    if(userpw != userpw2) {
        // 비밀번호가 일치하지 않음
        console.log('비밀번호가 일치하지 않습니다.');
        resultcode = 100;
        return resultcode;
    }
    // 아이디 중복 체크 후 비밀번호 암호화
    if(rows[0] == undefined){
     
      new Promise((resolve, reject) => {
        hasher({
          password: userpw
        }, async function(err, pass, salt, hash) {
          pass = hash;
          var randomNumber = Math.floor(10000 + Math.random() * 90000); // token_temp
          await conn.query(`CALL webdb.SP_REGISTER_USER(?,?,?,?,?,?,?,?,?,?,?,?,?);`, [uid, userid, pass, salt, user_name, user_email, user_role, user_type, youthAge_code, parentsAge_code, sex_class_code, emd_class_code, randomNumber ]);
        });
      });
     
    } else{
      // 아이디 중복
      console.log('이미 존재하는 아이디입니다.');
      resultcode = 100;
      return resultcode;
    }

  } catch(error) {
    console.log('mobile-login-service SignUp:'+error);
  } finally {
    if (conn) conn.release();
  }
  
  return resultcode;
};


exports.checkDuplicateID = async function(req, res) {
  var conn;
  var resultcode = 0;

  try {
    conn = await db.getConnection();
    // console.log('mobile-login-service checkDuplicateID');
    var id = req.params.userid;
    // console.log(id);
    var query = "SELECT userid FROM webdb.tb_user WHERE userid=?;"
    var checkdb = await conn.query(query, [id]);
    // console.log(checkdb.length);

    if (checkdb.length > 0){
      resultcode = 100;
      return resultcode;
    } else {
      return resultcode;
    }


  } catch(err){
    console.log('mobile-login-service checkDuplicateId:' + err);
  } finally{
    if(conn) conn.release();
  }
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
    if (conn) conn.release();
  }
};













/*
exports.date_check = async function(req, res) {
  var resultcode = 0;
  var conn;
  try{
    console.log('date_check');
    conn = await db.getConnection();
    var userid = req.user.userid;
    var query = "SELECT case when Timestampdiff(hour, Date_format(Str_to_date(a.strt_date, '%Y%m%d'),'%Y-%m-%d'),now()) >= 0 and Timestampdiff(hour, Date_format(Str_to_date(a.release_date, '%Y%m%d'),'%Y-%m-%d'),now()) <= 0 then "
      +"Timestampdiff(hour, now(), Date_format(Str_to_date(a.release_date, '%Y%m%d'),'%Y-%m-%d')) else 0 release expr"
//      +"when Timestampdiff(hour, Date_format(Str_to_date(a.strt_date, '%Y%m%d'),'%Y-%m-%d'),now()) < 0 and Timestampdiff(hour, Date_format(Str_to_date(a.release_date, '%Y%m%d'),'%Y-%m-%d'),now()) <= 0 then "
//      +"Timestampdiff(hour, now(),Date_format(Str_to_date(a.release_date, '%Y%m%d'),'%Y-%m-%d')) else 0 release expr"
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
    if (conn) conn.release();
  }
};
*/
