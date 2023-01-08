// import bcrypt from 'bcrypt';
// import { connect } from '../database/connection';
// import { generateJsonWebToken } from '../lib/generate_jwt';
// import { sendEmailVerify } from '../lib/nodemail';



const bcrypte = require('bcrypt');
const connect = require('../../utils/kth.connection');
const generateJsonWebToken = require('../../lib/generate_jwt');
const sendEmailVerify = require('../../lib/nodemailer')

exports.login = async function (req, res) {
    try {
        const { userid, password } = req.body;
        const conn = await connect();
        // Check is exists ID on database 
        const [verifyUserdb] = await conn.query('SELECT user_id, user_pw, email_verified FROM test WHERE user_id = ?', [user_id]);
        if (verifyUserdb.length == 0) {
            return res.status(401).json({
                resp: false,
                message: '자격 증명이 등록되지 않았습니다.'
            });
        }
        const verifyUser = verifyUserdb[0];
        // Check Email is Verified
        if (!verifyUser.email_verified) {
            resendCodeEmail(verifyUser.email);
            return res.status(401).json({
                resp: false,
                message: '메일을 확인해주세요.'
            });
        }
        // Check Password
        if (!await bcrypt.compareSync(user_pw, verifyUser.user_pw)) {
            return res.status(401).json({
                resp: false,
                message: '잘못된 비밀번호'
            });
        }
        const uidPersondb = await conn.query('SELECT user_id as uid FROM test WHERE user_id = ?', [user_id]); //
        const { uid } = uidPersondb[0][0]; //
        let token = generateJsonWebToken(uid);
        conn.end();
        return res.json({
            resp: true,
            message: '환영합니다!!!',
            token: token
        });
    }
    catch (err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }
};
exports.renweLogin = async function (req, res) {
    try {
        const token = generateJsonWebToken(req.idPerson);
        return res.json({
            resp: true,
            message: '청소년 톡talk에 오신 것을 환영합니다',
            token: token
        });
    }
    catch (err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }
};
exports.resendCodeEmail = async function (email) {
    const conn = await connect();
    var randomNumber = Math.floor(10000 + Math.random() * 90000);
    await conn.query('UPDATE test SET token_temp = ? WHERE user_email = ?', [randomNumber, user_email]);
    await sendEmailVerify('확인 코드', email, `<h1> 청소년톡talk </h1><hr> <b>${randomNumber} </b>`);
    conn.end();
};

// module.exports = {
//     login,
//     renweLogin,
//     resendCodeEmail,
// }
