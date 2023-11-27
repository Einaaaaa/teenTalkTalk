const path = require("path");
var express = require("express");
const axios = require('axios');
const nodemailer = require("nodemailer");
var json2xls = require('json2xls');
var fs = require('fs');
var XLSX = require('xlsx');
var router = express.Router();
//var checkAuth = require('../utils/checkauth');
var dataif_controller = require("../../controllers/common-controller/dataif-controller");
var code_controller = require("../../controllers/common-controller/codeData-controller");

const ensureAuth = require("../../utils/middleware/ensureAuth");
const asyncHandler = require("../../utils/middleware/asyncHandler");
const accessAuth = require("../../utils/middleware/accessAuth");

var codeName = require('../../public/js/home/getCodeName');

const passport = require('passport');

//로그인 시 출력하는 화면
router.get('/', ensureAuth, accessAuth(2), asyncHandler(async function (req, res) {
  var urltype = req.url.split('/')[1].split('=')[0];
  var crtpage = 1;
  var totalPage = 1;
  var pageSize = 6; //한 페이지에 보여줄 회원 정보 수
  if (urltype == '?search') { //검색어 입력
    var result = await dataif_controller.fetchDataByUserid(req, res);
  } else if (urltype == '?page') { //페이지 이동
    crtpage = req.url.split('=')[1]; //현재 페이지
    // 순서 수정
    var result = await dataif_controller.fetchData(req, res);
    if (crtpage == undefined) crtpage = 1; //현재 페이지가 없으면 1페이지로 설정
    if (crtpage < 1) crtpage = 1; //현재 페이지가 1보다 작으면 1페이지로 설정
    if (crtpage > Math.ceil(result.length / pageSize)) crtpage = Math.ceil(result.length / pageSize); //현재 페이지가 마지막 페이지보다 크면 마지막 페이지로 설정
    var start = (crtpage - 1) * pageSize;
    var end = crtpage * pageSize;
    totalPage = Math.ceil(result.length / pageSize);
    result = result.slice(start, end); //현재 페이지에 해당하는 회원 정보만 가져옴
  } else { //일반 접속
    var result = await dataif_controller.fetchData(req, res);
    totalPage = Math.ceil(result.length / pageSize);
    result = result.slice(0, pageSize);
  }
  var code_data = await code_controller.getUserCodeName();
  // console.log(req.session);
  crtpage = parseInt(crtpage); //현재 페이지
  res.render('dataif/mem',
    {
      posts: result,
      code_data: code_data,
      page: crtpage, //현재 페이지
      totalPage: totalPage, //총 페이지 수
      codeName: codeName.user_code_to_name,
      emd_code_to_name: codeName.emd_code_to_name,
      user_type_to_name: codeName.user_type_to_name,
      role_code_to_class: codeName.role_code_to_class, //권한
    });
}, 'dataif-router / error:'));


// 무화과 사용 로그 확인 페이지
router.get('/figManage/:id', ensureAuth, accessAuth(1), asyncHandler(async function (req, res) {
  var id = req.params.id; //회원 아이디
  var figUsage = await dataif_controller.fetchFigUsageByUid(req, res); //무화과 사용 로그
  var eventPart = await dataif_controller.fetchEventPartByUid(req, res); //행사 참여 로그
  res.render('dataif/figManage',
    {
      figUsage: figUsage,
      eventPart: eventPart,
      userid: id
    });
}, 'dataif-router / error:'));


router.post('/', asyncHandler(async function (req, res) {
  var result = await dataif_controller.fetchData(req, res);
  res.render('dataif/index', { posts: result });
}, 'dataif-router / error:'));


// 약관 설정 페이지
router.get('/terms', ensureAuth, accessAuth(1), asyncHandler(async function (req, res) {
    var result = await dataif_controller.fetchTermData(req, res);
    res.render('dataif/terms', { posts: result });
}, 'dataif-router / error:'));
router.post('/terms', asyncHandler(async function (req, res) {
    var result = await dataif_controller.updateTermData(req, res);
    res.redirect('/admin/dataif/terms');
}, 'dataif-router / error:'));


// 회원 정보 수정 페이지
router.get('/update/:id', ensureAuth, accessAuth(1), asyncHandler(async function (req, res) {
    //데이터 받아오기
    var result = await dataif_controller.fetchDataUserUpdate(req, res);
    var code_data = await code_controller.getCodeData(req, res);
    res.render('dataif/update', {
      post: result[0],
      code_data: code_data
    });
}, 'dataif-router / error:'));
router.post('/update/:id', asyncHandler(async function (req, res) {
    var result = await dataif_controller.update(req, res);
    if (result == 0) {res.redirect("/admin/dataif");} //비밀번호가 맞는 경우
    else { //비밀번호가 틀린 경우
      res.redirect("/admin/dataif/update/" + req.params.id);
    }
}, 'dataif-router / error:'));


// 회원 정보 삭제
router.get('/delete/:id', ensureAuth, accessAuth(1), asyncHandler(async function (req, res) {
    var result = await dataif_controller.deleteUser(req, res);
    res.redirect("/admin/dataif");
}, 'dataif-router delete/ error:'));

// 엑셀 다운로드
router.get('/excel', ensureAuth, accessAuth(1), asyncHandler(async function (req, res) {
    var result = await dataif_controller.fetchData(req, res); //회원 정보 가져오기
    var xls = json2xls(result); //json 데이터를 엑셀 파일로 변환
    fs.writeFileSync('user_data.xlsx', xls, 'binary'); //엑셀 파일 저장
    res.download('user_data.xlsx'); //엑셀 파일 다운로드
}, 'dataif-router excel/ error:'));

//테스트, 사용안하는 코드

// 비밀번호 초기화
router.get('/resetPW/:id', asyncHandler(async function (req, res) {
  var result = await dataif_controller.resetPW(req, res);
  res.redirect('/admin/dataif');
}, 'dataif-router resetPW error:'));

// 푸시 알림 페이지
router.get('/push', ensureAuth, asyncHandler(async function (req, res) {
  var userDatas = await dataif_controller.fetchData(req, res);
  res.render('dataif/push', { posts: userDatas });
}, 'dataif-router / error:'));

router.post('/push', ensureAuth, asyncHandler(async function (req, res) {
  const serverKey = process.env.FCM_SERVER_KEY; // 서버키 가져오기
  const fcmUrl = 'https://fcm.googleapis.com/fcm/send'; // FCM 서버 주소
  const { title, content } = req.body; // 폼 데이터에서 제목과 내용을 가져오기
  // var userDatas = await dataif_controller.fetchData(req, res); // db에서 registration_ids 가져오기
  const message = {
    notification: {
      title: title,
      body: content,
    },
    // 추가적인 페이로드 설정
    // data: {
    //   key1: 'value1',
    //   key2: 'value2',
    // },
    to : 'RegistrationToken', // RegistrationToken을 설정
    // registration_ids: ['RegistrationToken1', 'RegistrationToken2', 'RegistrationToken3'], // 여러 명에게 보낼 경우 RegistrationToken을 배열로 설정
  };
  try {
    const response = await axios.post(fcmUrl, message, {
      headers: {
        'Content-Type': 'application/json', // 요청 헤더
        Authorization: `key=${serverKey}`, // 서버 키를 헤더에 포함시켜 보낸다
      },
    });

    console.log('푸시 알림이 성공적으로 전송되었습니다:', response.data);
    res.redirect('/admin/push'); // 알림 전송 후 리디렉션할 경로를 설정합니다.
  } catch (error) {
    // console.error('푸시 알림 전송 중 오류가 발생했습니다:', error);
    res.redirect('/admin/push'); // 오류 발생 시 리디렉션할 경로를 설정합니다.
  }
}));

// 아이디 찾기
router.post('/findID', asyncHandler(async function (req, res) {
  var result = await dataif_controller.findID(req, res);
  res.redirect('/admin/dataif/findID/' + result);
}, 'dataif-router / error:'));
router.get('/findID', asyncHandler(async function (req, res) {
  res.render('dataif/findID', { id: '' });
}, 'dataif-router / error:'));
router.get('/findID/:id', asyncHandler(async function (req, res) {
  var id = req.params.id;
  res.render('dataif/findID', { id: id });
}, 'dataif-router / error:'));

router.post('/sendAuthNum', asyncHandler(async function (req, res) {
  // 인증번호 생성
  var email = req.body.email;
  var tempPW = Math.floor(Math.random() * 1000000)+100000;
  console.log(tempPW);
  let transporter = nodemailer.createTransport({
    service: 'naver',
    host: 'smtp.naver.com',
    port: 587,
    auth: {
        user: process.env.NODEMAILER_USER,
        pass: process.env.NODEMAILER_PASS
    }
      });
      let mailOptions = {
        from: process.env.NODEMAILER_USER,
        to: email,
        subject: '요청하신 인증번호입니다.',
        text: '인증번호 : '+tempPW+''
    };
    transporter.sendMail(mailOptions, function(error, info){
      if (error) {
          console.log(error);
      } else {
          console.log('Email sent: ' + info.response);
      }
  });
  // 인증번호 저장
  var result = await dataif_controller.saveAuthNum(req, res, tempPW);
  res.redirect('/admin/findPW');
  }, 'dataif-router / error:'));

module.exports = router;