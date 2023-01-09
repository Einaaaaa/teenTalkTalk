const path = require("path");
var express = require("express");
var router = express.Router();
//var checkAuth = require('../utils/checkauth');
var dataif_controller = require("../../controllers/mobile-controller/dataif-controller");
var login_controller = require("../../controllers/mobile-controller/login-controller");
const passport = require('passport');
/*
var Post = require('../../models/Post');

var multer = require('multer');  //multer 모듈 import
var uploadImg = multer({dest: 'public/upload/img/'}); //업로드 경로 설정
var uploadFile = multer({dest: 'public/upload/file/'}); //업로드 경로 설정
//multer({ dest: 'uploads/', limits: { fileSize: 5 * 1024 * 1024 } });
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'public/uploads/')
  },
  filename: function (req, file, cb) {
    cb(null, new Date().valueOf() + path.extname(file.originalname))
  }
})

const fileFilter = function (req, file, cb) {
  let typeArray = file.mimetype.split('/');
  let fileType = typeArray[1];
  if (fileType == 'jpg' || fileType == 'png' || fileType == 'jpeg' || fileType == 'gif') {
      cb(null, true);
  } else {
      req.fileValidationError = "jpg,jpeg,png,gif 파일만 업로드 가능합니다.";
      cb(null, false)
  }
}

const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
      fileSize: 5 * 1024 * 1024
  }
});
*/

/*
router.post("/dataif", checkAuth, async function(req, res) {
    console.log('dataif:'+req.user)
    try{
        // 로그인 확인을 위해 컨트롤러 호출
        var result = await main_controller.dataif(req, res);

        res.render('dataif', {'id':req.user});
    } catch(error) {
        console.log('main-router dataif error:'+error);
    }
});
*/
router.get('/user', async function(req, res){
  try{
    var result = await dataif_controller.fetchData(req, res);
/*
    var rtnparams=[];
    rtnparams.totalPages=result.totalPages;
    rtnparams.page=result.page;
    rtnparams.srchword=req.query.srchword;
    delete result.totalPages;
    delete result.page;
*/
    res.render('dataif/index', {posts:result});//, rtnparams:rtnparams
  } catch(error) {
    console.log('dataif-router / error:'+error);
  }
});


router.post('/user', async function(req, res){
  try{
    console.log("req.user");
    var result = await dataif_controller.fetchData(req, res);
    res.render('dataif/index', {posts:result});
  } catch(error) {
    console.log('dataif-router / error:'+error);
  }
});


// create
router.put('/', async function(req, res){
  try{
    var result = await dataif_controller.create(req, res);
    res.redirect('/dataif');
  } catch(error) {
    console.log('dataif-router create error:'+error);
  }
});



// 로그인 라우터
router.get('/login', function (req, res) {
  try{
    //console.log('login-router login');
    res.render('dataif/login');
  } catch(error) {
    console.log('login-router login error:'+error);
  }
});
/*
router.post("/login", async function(req, res) {
  try{
    // 로그인 확인을 위해 컨트롤러 호출
    //console.log(req.body);
    var result = await login_controller.SignIn(req, res);
    res.send(result);
  } catch(error) {
    console.log('login-router login:'+error);
  }
});

const LocalStrategy = require('passport-local').Strategy;
passport.use('local-login', new LocalStrategy({
  usernameField: 'userid',
  passwordfield: 'password',
  passReqToCallback: true,
}, async function(req, username, password, done) {
  //console.log(username);
  try{
    var conn = await db.getConnection();
    const query = 'SELECT userid, password, salt, name FROM webdb.member where userid='+username;
    var rows = await conn.query(query);
    if (rows.length) {
      return done(null, {'userid': rows[0].userid})
    } else {
        return done(null, false, {'message': 'your userid is not found'})
    }
  } catch(error) {
    console.log('login-router login:'+error);
    return done(error);
  } finally {
    if (conn) conn.end();
  }
}));

//serialize 부분을 작성해야 server.js의 post에서 call한
//passport.authenticate 함수가 정상 작동한다.
passport.serializeUser((user,done)=>{ 
  //console.log('serializeUser:'+user.userid);
  done(null,user.userid);
});

passport.deserializeUser((userid,done)=>{
  //console.log('deserializeUser:'+user);
  done(null,userid);
});
*/
//이게 동작하면 authenticate() 메서드 실행되고 이 값처리는 위의 passport부분에서 실행한다. 

router.post('/login', passport.authenticate('local-login', {
  successRedirect: '/admin/loginSuccess', //인증성공시 이동하는화면주소
  failureRedirect: '/admin/loginFailure', //인증실패시 이동하는화면주소
  failureFlash: true //passport 인증하는 과정에서 오류발생시 플래시 메시지가 오류로 전달됨.
}));

router.get("/loginSuccess", function(req, res) {
  res.render('dataif/mem'); //redirect('/admin/login');
  //res.json({msg:'0'});
});

router.get("/loginFailure", function(req, res) {
  var rtnMsg;
  var err = req.flash('error');
  if(err) rtnMsg = err;
  //res.json({success: false, msg: rtnMsg})
  res.redirect('/admin/login');
  //res.json({errMsg:msg});
});

//로그인끝

router.post("/login-check", async function(req, res) {
  try{
    // 로그인 확인을 위해 컨트롤러 호출
    console.log('login-router login-check');
    var result = await login_controller.login_check(req, res);
    //console.log('login-router login-check result:'+result);
    switch(result){
      case 1 : res.json({success: false, msg: '해당 유저가 존재하지 않습니다.'}); break;
      //case 2 : res.json({success: false, msg: '해당 유저가 존재하지 않거나 비밀번호가 일치하지 않습니다.'}); break;
      case 2 : 
      case 3 : res.json({success: true}); break;
    }
  } catch(error) {
    console.log('login-router login-check error:'+error);
  }
});

router.post("/signup-check", async function(req, res) {
  try{
    // 회원 확인을 위해 컨트롤러 호출
    var result = await login_controller.login_check(req, res);
    //console.log('login-router signup-check result:'+result);
    switch(result){
      case 1 : res.json({success: true}); break;
      case 2 : 
      case 3 : res.json({success: false, msg: '해당 유저가 존재합니다.'}); break;
    }
  } catch(error) {
    console.log('login-router signup-check error:'+error);
  }
});

// 로그아웃
router.get("/logout", function(req, res) {
  //console.log("clear cookie");
  // 로그아웃 쿠키 삭제
  res.clearCookie('userid');
  res.clearCookie('username');
  // 세션정보 삭제
  //console.log("destroy session");
  req.session.destroy();
  //res.sendFile(path.join(__dirname, "../public/login.html"));
  req.logout();
  res.redirect('/');
});


// 사용자등록
router.get("/signup", function(req, res) {
  res.render('dataif/signup');
});

router.post("/signup", async function(req, res) {
  try{
    // 사용자등록 컨트롤러 호출
    
    var result = await login_controller.signUp(req, res);
    //res.send({errMsg:result});
    //if(result==0) res.json({success: true, msg:'등록하였습니다.'});
    //else res.json({success: false, msg:'등록실패하였습니다.'});
    if(result==0) res.redirect('/mobile/login');
    else res.redirect('/mobile/signup');
  } catch(error) {
    console.log('login-router signup error:'+error);
  }
});


// New
router.get('/new', function(req, res){
  console.log('dataif-router new');
  res.render('dataif/new', {parent_board_id:req.params.id});
});

router.get('/:id/new', function(req, res){
  res.render('dataif/new', {parent_board_id:req.params.id});
});


// show
router.get('/:id', async function(req, res){
  try{
    var result = await dataif_controller.retrieveData(req, res);
    res.render('dataif/show', {post:result});
  } catch(error) {
    console.log('dataif-router show error:'+error);
  }
});

// edit
router.get('/:id/edit', async function(req, res){
  try{
    var result = await dataif_controller.retrieveData(req, res);
    
    res.render('dataif/edit', {post:result});
  } catch(error) {
    console.log('dataif-router edit error:'+error);
  }
});

// update
router.put('/:id', async function(req, res){
  try{
    var result = await dataif_controller.update(req, res);
    //console.log(result)
    //if(result) res.render('dataif/edit', {post:result});
    //else res.render('dataif/edit', {post:result});
    
    res.redirect("/dataif");
  } catch(error) {
    console.log('dataif-router update error:'+error);
  }
});

// destroy
router.delete('/:id', async function(req, res){
  try{
    var result = await dataif_controller.delete(req, res);

    if(result) res.json({success: true, msg:'삭제하였습니다.'});
    else res.json({success: false, msg:'삭제실패하였습니다.'});

  } catch(error) {
    console.log('dataif-router destroy error:'+error);
  }
});

router.get('/datapermit', async function(req, res){
  try{
    var result = await dataif_controller.fetchData(req, res);
    res.render('dataif/datapermit', {posts:result});
  } catch(error) {
    console.log('dataif-router /datapermit error:'+error);
  }
});


module.exports = router;