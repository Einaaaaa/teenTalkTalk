var login_service = require("../../services/login-service");

// 회원로그인 컨트롤러, 사용 안됨..?
exports.SignIn = async function(req, res) {
  try{
    // console.log('login-controller', req.body);
    const result = await login_service.SignIn(req);
    console.log('login-controller SignIn');
    if (result.code == 0) {
      console.log("login-controller SiginIn 로그인 성공");
      // 로그인 성공시 쿠키 생성
      res.cookie('userid', result.data.userid);
      res.cookie('username', result.data.user_name, {
        maxAge: 60 * 60 * 1000, // 만료 시간
        path: "/" // 쿠키가 전송될 경로
      });
      // 로그인 후 사용자 정보를 세션에 저장
      req.session.user = result;
    }
    // console.log('login-controller result', result);
    return result;
  } catch(error) {
    console.log('login-controller SignIn:'+error);
  }
};


// 회원가입 컨트롤러
exports.signUp = async function(req, res) {
  try{
    var result = await login_service.signUp(req);
    return result;
  } catch(error) {
    console.log('login-controller login_check:'+error);
  }
};

exports.getAttendance = async function(req, res) {
  try{
    var result = await login_service.getAttendance(req);
    return result;
  } catch(error) {
    console.log('login-controller getAttendance:'+error);
  }
};

exports.checkAttendance = async function(req, res) {
  try{
    var result = await login_service.checkAttendance(req);
    return result;
  } catch(error) {
    console.log('login-controller checkAttendance:'+error);
  }
};


