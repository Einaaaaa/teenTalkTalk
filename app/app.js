//공용 모듈1
const express = require('express'); //express
const axios = require('axios'); // axios 라이브러리 import
const bodyParser = require('body-parser'); //body-parser
const dotenv = require("dotenv"); //환경변수
const openai = require('openai');

//모바일 모듈
// const cors = require('cors'); //cors
// const path = require('path'); //경로
// const createServer = require('http'); //http 서버
// const {promisfy} = require('promisfy'); //비동기 처리

dotenv.config();

const app = express(); //express 객체 생성
const session = require("express-session"); //세션
const passport = require('passport'); //passport
const flash = require('express-flash'); //flash 메시지
const initPassport = require('./src/utils/passport'); //passport 설정

// const port = process.env.PORT;


//라우팅
const routerAdminDataif = require("./src/routes/admin-router/admin-dataif-router");
const routerAdminLogin = require("./src/routes/admin-router/admin-login-router");
const routerAdminMain = require("./src/routes/admin-router/admin-main-router");
const routerAdminpolicy = require("./src/routes/admin-router/admin-policy-router");
const routerAdminCode = require("./src/routes/admin-router/admin-codeData-router");
const routerError = require("./src/routes/admin-router/admin-error-router");

const routerMobileLogin = require("./src/routes/mobile-router/mobile-login-router");
const routerMobileMain = require("./src/routes/mobile-router/mobile-main-router");
const routerMobilePolicy = require("./src/routes/mobile-router/mobile-policy-router");
const routerMobileCode = require("./src/routes/mobile-router/mobile-codeData-router");
const routerMobileUser = require("./src/routes/mobile-router/mobile-user-router");
const routerMobileDataif = require("./src/routes/mobile-router/mobile-dataif-router");
const routerMobileEvent = require("./src/routes/mobile-router/mobile-event-router");

const routerChatBot = require("./src/routes/chatbot-router/chatbot-router");

//앱 세팅
app.set("views", "./src/views"); //템플릿 파일 경로(views)
app.set("view engine", "ejs"); //템플릿 엔진(ejs)

//세션
app.use(session({
    secret: "eqz9rPfMT8qO+EUHFW",
    resave: false, 
    saveUninitialized: true,
    rolling: true,
  }));


app.use(passport.initialize()); //passport 초기화
app.use(passport.session()); //passport 세션 사용
initPassport(); //passport 설정
app.use(flash()); //flash 메시지 사용

app.use(express.static(`${__dirname}/src/public`)); //정적파일 경로

app.use(bodyParser.json()); //json형식의 데이터를 받을 수 있게
app.use(bodyParser.urlencoded({ extended: true })); //urlencoded형식의 데이터를 받을 수 있게

// FCM을 통한 푸시알림
// app.use("/fcm", require("./src/routes/fcm-router"));

// app.use(cors());
app.use("/admin/auth",routerAdminLogin); //관리자 로그인
app.use("/admin/dataif",routerAdminDataif); //관리자 데이터 인터페이스
app.use("/admin/main",routerAdminMain); //관리자 메인
app.use("/admin/policy",routerAdminpolicy); //관리자 정책
app.use("/admin/codeData",routerAdminCode); //관리자 코드데이터(공통코드)
app.use("/admin/error",routerError); //관리자 에러

app.use("/mobile/login",routerMobileLogin); // 모바일
app.use("/mobile/main",routerMobileMain); // 모바일
app.use("/mobile/policy",routerMobilePolicy); // 모바일
app.use("/mobile/codeData",routerMobileCode); // 모바일
app.use("/mobile/user",routerMobileUser); // 모바일
app.use("/mobile/dataif", routerMobileDataif); //모바일
app.use("/mobile/event", routerMobileEvent); //모바일

app.use("/chatbot", routerChatBot); //챗봇


module .exports = app;