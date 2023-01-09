//공용 모듈
const express = require('express');
const bodyParser = require('body-parser');
const dotenv = require("dotenv");

//모바일 모듈
const cors = require('cors');
const path = require('path');
const http = require('http');
const {promisfy} = require('promisfy');
const {createServer} = require('http');

dotenv.config();

const app = express();
app.use(express.static('public'));
const session = require("express-session");
const passport = require('passport');
const flash = require('express-flash');
const initPassport = require('./src/utils/passport');



// test
const port = 3000;

app.listen(port, () => {
  console.log(`APP : SERVER RUN ON PORT ${port}`)
})

// app.httpServer = createServer(app);

// app.listen = async function(port) {
//   console.log('SERVER RUN ON PORT ${port}')
//   await app.httpServer.listen(port);
  
// }


app.get('/welcome', (req, res)=>{
  res.send('heehee');
})


// webdb - test에서 data select
// const pool = require('./src/utils/kth.connection');

// app.get('/get', function(req, res){
//   var sql = 'select * from test';
//   pool.query(sql, function(err, id, fields){
//     var user_id = req.id;
//     console.log('id', id);
//     console.log('fields', fields);
//     if(id){
//       var sql = 'select * from test'
//       pool.query(sql, function(err, id, fields){
//         if(err){
//           console.log(err);
//         } else {
//           res.json(id);
//           console.log('user : ' , user_id);
//           console.log('user: ', fields);
//         }
//       })
//     }
//   })
// })

//라우팅
// const routeUser = require('./src/routes/mobile-router/user_routes');
// const routeAuth = require('./src/routes/mobile-router/auth_routes');
const routerAdmin = require("./src/routes/admin-router/dataif-router");
const routerMobile = require("./src/routes/mobile-router/dataif-router");

// //앱 세팅
app.set("views", "./src/views");
app.set("view engine", "ejs");

app.use(session({
    secret: "eqz9rPfMT8qO+EUHFW",
    resave: false, 
    saveUninitialized: true,
    rolling: true,
    cookie: {
      secure: true,
      expires: 600 * 1000
   }
  }));

app.use(passport.initialize());
app.use(passport.session());
initPassport();
app.use(flash());

// app.apiRoutes = {
//     user : '/api',
//     auth : '/api',
// }
// app.use(app.apiRoutes.user, routeUser);
// app.use(app.apiRoutes.auth, routeAuth);

app.use(express.static(`${__dirname}/src/public`)); //정적파일 경로
app.use(bodyParser.json()); //json형식의 데이터를 받을 수 있게
app.use(bodyParser.urlencoded({ extended: true })); //urlencoded형식의 데이터를 받을 수 있게
app.use("/admin",routerAdmin);
app.use("/mobile",routerMobile);


// mobile - middleware
app.use(cors);
app.use(express.json());
// app.use(express.urlencoded({extended:false}));




module.exports = app;




