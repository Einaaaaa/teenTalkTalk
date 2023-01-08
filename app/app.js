//공용 모듈
const express = require('express');
const bodyParser = require('body-parser');
const dotenv = require("dotenv");

//모바일 모듈
const cors = require('cors');
const path = require('path');
const http = require('http');
const {promisfy} = require('promisfy');

// dotenv.config();

const app = express();
app.use(express.static('public'));
const session = require("express-session");
const passport = require('passport');
const flash = require('express-flash');
const initPassport = require('./src/utils/passport');

//라우팅
const routeUser = require('./src/routes/mobile-router/user_routes');
const routeAuth = require('./src/routes/mobile-router/auth_routes');
const routerAdmin = require("./src/routes/admin-router/dataif-router");
// const routerMobile = require("./src/routes/mobile-router/user_routes");

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

app.apiRoutes = {
    user : '/apiUser',
    auth : '/apiAuth',
}
app.use(app.apiRoutes.user, routeUser);
app.use(app.apiRoutes.auth, routeAuth);

app.use(express.static(`${__dirname}/src/public`)); //정적파일 경로
app.use(bodyParser.json()); //json형식의 데이터를 받을 수 있게
app.use(bodyParser.urlencoded({ extended: true })); //urlencoded형식의 데이터를 받을 수 있게
app.use("/admin",routerAdmin);
//app.use("/mobile",routeUser); 


// mobile - middleware
app.use(cors);
app.use(express.json());
app.use(express.urlencoded({extended:false}));


// test
const port = 3000;
app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
  })
app.get('/welcome', (req, res)=>{
    res.send('heehee');
})

//=========


module .exports = app;



// exports.App = class {

//     constructor() {
//         this.apiRoutes = {
//             user: '/api',
//             auth: '/api',
//             // post: '/api',
//             // notification: '/api',
//             // story: '/api',
//             // chat: '/api',
//         };
//         this.app = express();
//         this.httpServer = http.createServer(this.app);
//         this.middlewares();
//         this.routes();
//         // this.configServerSocket();
        
//     }
//     middlewares() {
//         this.app.use(cors());
//         this.app.use(express.json());
//         this.app.use(express.urlencoded({ extended: false }));
//         // this.app.use(express.static(path.resolve('uploads/profile')));
//         // this.app.use(express.static(path.resolve('uploads/profile/cover')));
//         // this.app.use(express.static(path.resolve('uploads/posts')));
//         // this.app.use(express.static(path.resolve('uploads/stories')));
//     }
//     routes() {
//         this.app.use(this.apiRoutes.user, routesUser);
//         this.app.use(this.apiRoutes.auth, routesAuth);
//         // this.app.use(this.apiRoutes.post, routesPost);
//         // this.app.use(this.apiRoutes.notification, routesNotifications);
//         // this.app.use(this.apiRoutes.story, routesStory);
//         // this.app.use(this.apiRoutes.chat, routesChat);
//     }
//     // configServerSocket() {
//     //     const io = new ServerSocket(this.httpServer);
//     //     socketChatMessages(io);
//     // }


//     async listen(port) {
//         await this.httpServer.listen(port);
//         console.log(`APP : SERVER RUN ON PORT ${port}`);
//     }
// }


