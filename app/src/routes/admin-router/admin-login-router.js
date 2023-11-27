const path = require("path");
var express = require("express");
var router = express.Router();
var login_controller = require("../../controllers/common-controller/login-controller");
var code_controller = require("../../controllers/common-controller/codeData-controller");

const passport = require('passport');

const ensureAuth = require("../../utils/middleware/ensureAuth");
const asyncHandler = require("../../utils/middleware/asyncHandler");


// 로그인 라우터
router.get('/login', function (req, res) {
  try{
    res.render('dataif/login');
  } catch(error) {
    console.log('login-router login error:'+error);
  }
});
router.post("/login", async function(req, res) {
  try{
    // 로그인 확인을 위해 컨트롤러 호출)
    //json 형식으로 결과값을 받아옴
    var result = await login_controller.SignIn(req, res);
    // result.code 값을 login.ejs로 전달
    if(result.code == 0){
      res.status(200).send({ message: '로그인에 성공했습니다.', code: result.code, role : req.session.user.data.user_role });
    } else {
      res.status(result.code).send({ message: result.msg, code: result.code });
    }
  } catch(error) {
    console.log('login-router login:'+error);
  }
});


// 로그아웃
router.get("/logout", function(req, res) {
  console.log("clear cookie");
  // 로그아웃 쿠키 삭제
  res.clearCookie('userid');
  res.clearCookie('username');
  // 세션정보 삭제
  console.log("destroy session");
  req.session.destroy();
  //res.sendFile(path.join(__dirname, "../public/login.html"));
  req.logout(() => {
    res.redirect('/admin/auth/login');
  });
});


// 사용자등록
router.get("/signup",ensureAuth, asyncHandler(async function (req, res) {
  var code_data = await code_controller.getCodeData(req, res);
  res.render('dataif/signup', {title: '회원가입', sess: req.session,
    code_data: code_data
  });
}, 'dataif-router / error:'));
router.post("/signup", async function(req, res) {
  try{
    // 사용자등록 컨트롤러 호출
    var result = await login_controller.signUp(req, res);
    // console.log(result);
    console.log('login-router signup result:'+result.code);
    if (result.code == 0) {
      console.log('login-router signup success');
      res.status(200).send({ message: '회원 등록에 성공했습니다.', code: 0});
    } else {
      console.log('login-router signup fail');
      res.status(400).send({ message: result.msg, code: result.code });
    }
  } catch(error) {
    console.log('login-router signup error:', error);
    res.status(500).send({ message: '회원 등록 중 오류가 발생했습니다.', code: -1 });
  }
});




//테스트용

//출석체크 로직
router.get('/attendance', async function (req, res) {
  try{
    var attendance = await login_controller.getAttendance(req, res);
    // var today = new Date().toISOString().slice(0, 10); // 오늘 날짜
    var today = new Date();
    today = new Date(today).toLocaleDateString('ko-KR', {
      timeZone: 'Asia/Seoul',
      year: 'numeric',
      month: 'numeric',
      day: 'numeric'
    });
    // at_date는 마지막 출석 날짜
    var at_date = attendance[attendance.length - 1].attendance_date;
    at_date = new Date(at_date).toLocaleDateString('ko-KR', {
      timeZone: 'Asia/Seoul',
      year: 'numeric',
      month: 'numeric',
      day: 'numeric'
    });

    // 출석 내역이 있고, 마지막 출석 날짜가 오늘 날짜와 같으면 이미 출석한 것
    if(attendance.length && at_date == today){
      console.log("이미 출석하셨습니다.");
      res.redirect('/admin/dataif');
    } else {
      var result = await login_controller.checkAttendance(req, res);
      console.log("출석 체크 완료");
      res.redirect('/admin/dataif');
    }
  } catch(error) {
    console.log('login-router login error:'+error);
  }
});

// 테스트 페이지, 캘린더 정보
router.get('/calendar', async function (req, res) {
  try{
    // console.log(req.session.user.data.userid);
    var result = await login_controller.getAttendance(req, res);
    //현재 month 구하기
    var date;
    var today = new Date();
    var month = new Date(today).toLocaleDateString('ko-KR', {
      timeZone: 'Asia/Seoul',
      month: 'numeric',
    }).split('월')[0];
    // result에서 현재 개월의 출석 날짜만 뽑아서 배열로 만들기
    var attendance = [];
    for(var i = 0; i < result.length; i++){
      date = new Date(result[i].attendance_date).toLocaleDateString('ko-KR', {
        timeZone: 'Asia/Seoul',
        month: 'numeric',
      }).split('월')[0];
      if(date == month){
        at_date = new Date(result[i].attendance_date).toLocaleDateString('ko-KR', {
          timeZone: 'Asia/Seoul',
          day: 'numeric'
        }).split('일')[0];
        at_date = Number(at_date);
        // attendance에 중복된 날짜가 없으면 추가
        if(!attendance.includes(at_date)) attendance.push(at_date);
      }
    }
    return attendance;
  } catch(error) {
    console.log('login-router login error:'+error);
  }
});

module.exports = router;