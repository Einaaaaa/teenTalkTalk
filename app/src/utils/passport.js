const LocalStrategy = require('passport-local').Strategy;
const passport = require('passport');
var bkfd2Password = require("pbkdf2-password");
var hasher = bkfd2Password();
var db = require('../utils/db');

module.exports = () => {
    passport.use('local-login', new LocalStrategy({
        usernameField: 'userid',
        passwordfield: 'password',
        passReqToCallback: true,
    }, async function(req, username, password, done) {
        //console.log('passport username:'+username);
        var conn;
        try{
          conn = await db.getConnection();
            const query = 'SELECT userid, password, salt, name, user_type, board_idx FROM webdb.tb_user where userid="'+username+'"';
            var rows = await conn.query(query);
            if (rows.length) {
                var user = rows[0]; // 적절한 유저정보가 존재하는 경우
                return hasher(
                  { password: password, salt: user.salt },
                  function (err, pass, salt, hash) {
                    if (hash === user.password) { // 사용자의 비밀번호가 올바른지 확인
                      //console.log('passport user:', user);
                      done(null, user); // user 라는 값을 passport.serializeUser의 첫번째 인자로 전송
                    }
                    else done(null, false, {'message': '입력정보가 정확하지 않습니다.'});//password
                });
                //return done(null, {'userid': rows[0].userid})
            } else {
                return done(null, false, {'message': '입력정보가 정확하지 않습니다.'});//userid
            }
        } catch(error) {
            console.log('passport login:'+error);
            return done(error);
        } finally {
            if (conn) conn.end();
        }
    }));

    //serialize 부분을 작성해야 server.js의 post에서 call한
    //passport.authenticate 함수가 정상 작동한다.
    passport.serializeUser((user,done)=>{ 
        //console.log('serializeUser:'+user.userid);
        done(null,user);
    });

    passport.deserializeUser((user,done)=>{
        //console.log('deserializeUser:'+user);
        done(null,user);
    });
}