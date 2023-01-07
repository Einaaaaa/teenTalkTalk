
const path = require('path');
const fs = require('fs-extra');
const bcrypte = require('bcrypt');
// const v4 = require('uuid');
const { uuid } = require('uuidv4');
const connect = require('../../utils/kth.connection');
const sendEmailVerify = require('../../lib/nodemailer');

// import fs from 'fs-extra';
// import bcrypt from 'bcrypt';
// import { v4 as uuidv4 } from 'uuid';
// import { connect } from '../database/connection';
// import { sendEmailVerify } from '../lib/nodemail';


// const createUser = async (req, res) => {
exports.createUser = async function(req, res) {
    try {
        const { username, fullname, email, password } = req.body;
        
        const conn = await connect();
        const [existsEmail] = await conn.query('SELECT email FROM tb_user WHERE email = ?', [email]);
        if (existsEmail.length > 0) {
            return res.status(401).json({
                resp: false,
                message: '메일이 이미 존재합니다!'
            });
        }
        // let salt = bcrypt.genSaltSync();
        // const pass = bcrypt.hashSync(password, salt);
        // var randomNumber = Math.floor(10000 + Math.random() * 90000);
        // await conn.query(`CALL SP_REGISTER_USER(?,?,?,?,?,?,?);`, [uuidv4(), fullname, username, email, pass, uuidv4(), randomNumber]);
        // await sendEmailVerify('확인 코드', email, `<h1> 청소년 톡talk </h1><hr> <b>${randomNumber} </b>`);
        conn.end();
        return res.json({
            resp: true,
            message: '성공적으로 등록된 사용자'
        });
    }
    catch (err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }
};


// export const getUserById = async (req, res) => {
//     try {
//         const conn = await connect();
//         const [userdb] = await conn.query(`CALL SP_GET_USER_BY_ID(?);`, [req.idPerson]);
//         const posters = await conn.query('  SELECT COUNT(person_uid) AS posters FROM posts WHERE person_uid = ?', [req.idPerson]);
//         const friends = await conn.query('SELECT COUNT(person_uid) AS friends FROM friends WHERE person_uid = ?', [req.idPerson]);
//         const followers = await conn.query('SELECT COUNT(person_uid) AS followers FROM followers WHERE person_uid = ?', [req.idPerson]);
//         conn.end();
//         return res.json({
//             resp: true,
//             message: 'Get User by id',
//             user: userdb[0][0],
//             posts: {
//                 'posters': posters[0][0].posters,
//                 'friends': friends[0][0].friends,
//                 'followers': followers[0][0].followers
//             },
//         });
//     }
//     catch (err) {
//         return res.status(500).json({
//             resp: false,
//             message: err
//         });
//     }
// };
exports.verifyEmail = async function (req, res) {
    try {
        const conn = await connect();
        const [codedb] = await conn.query('SELECT token_temp FROM tb_user WHERE email = ? LIMIT 1', [req.params.email]);
        const { token_temp } = codedb[0];
        if (req.params.code != token_temp) {
            return res.status(401).json({
                resp: false,
                message: '확인 실패'
            });
        }
        await conn.query('UPDATE tb_user SET email_verified = ?, token_temp = ? WHERE email = ?', [true, '', req.params.email]);
        conn.end();
        return res.json({
            resp: true,
            message: '성공적으로 검증되었습니다...'
        });
    }
    catch (err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }
};


// export const updatePictureCover = async (req, res) => {
//     var _a;
//     try {
//         const coverPath = (_a = req.file) === null || _a === void 0 ? void 0 : _a.filename;
//         const conn = await connect();
//         const imagedb = await conn.query('SELECT cover FROM person WHERE uid = ? LIMIT 1', [req.idPerson]);
//         if (imagedb[0][0].cover != null) {
//             await fs.unlink(path.resolve('uploads/profile/cover/' + imagedb[0][0].cover));
//         }
//         await conn.query('UPDATE person SET cover = ? WHERE uid = ?', [coverPath, req.idPerson]);
//         conn.end();
//         return res.json({
//             resp: true,
//             message: 'Updated Cover'
//         });
//     }
//     catch (err) {
//         return res.status(500).json({
//             resp: false,
//             message: err
//         });
//     }
// };
// export const updatePictureProfile = async (req, res) => {
//     var _a;
//     try {
//         const profilePath = (_a = req.file) === null || _a === void 0 ? void 0 : _a.filename;
//         const conn = await connect();
//         const imagedb = await conn.query('SELECT image FROM person WHERE uid = ? LIMIT 1', [req.idPerson]);
//         if (imagedb[0].length > 0) {
//             if (imagedb[0][0].image != 'avatar-default.png') {
//                 await fs.unlink(path.resolve('uploads/profile/' + imagedb[0][0].image));
//             }
//         }
//         await conn.query('UPDATE person SET image = ? WHERE uid = ?', [profilePath, req.idPerson]);
//         conn.end();
//         return res.json({
//             resp: true,
//             message: 'Updated Profile'
//         });
//     }
//     catch (err) {
//         return res.status(500).json({
//             resp: false,
//             message: err
//         });
//     }
// };
// export const updateProfile = async (req, res) => {
//     try {
//         const { user, description, fullname, phone } = req.body;
//         const conn = await connect();
//         await conn.query('UPDATE users SET username = ?, description = ? WHERE person_uid = ?', [user, description, req.idPerson]);
//         await conn.query('UPDATE person SET fullname = ?, phone = ? WHERE uid = ?', [fullname, phone, req.idPerson]);
//         conn.end();
//         return res.json({
//             resp: true,
//             message: 'updated profile'
//         });
//     }
//     catch (err) {
//         return res.status(500).json({
//             resp: false,
//             message: err
//         });
//     }
// };
exports.changePassword = async function(req, res) {
    try {
        const { currentPassword, newPassword } = req.body;
        const conn = await connect();
        const passdb = await conn.query('SELECT passwordd FROM tb_user WHERE userid = ?', [req.idPerson]);
        if (!bcrypt.compareSync(currentPassword, passdb[0][0].passwordd)) {
            return res.status(400).json({
                resp: false,
                message: '비밀번호가 일치하지 않습니다'
            });
        }
        const salt = bcrypt.genSaltSync();
        const newPass = bcrypt.hashSync(newPassword, salt);
        await conn.query('UPDATE tb_user SET passwordd = ? WHERE userid = ?', [newPass, req.idPerson]);
        conn.end();
        return res.json({
            resp: true,
            message: '비밀번호가 성공적으로 변경되었습니다.',
        });
    }
    catch (err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }
};

// module.exports = {
//     createUser,
//     verifyEmail,
//     changePassword
// }


// export const changeAccountPrivacy = async (req, res) => {
//     try {
//         const conn = await connect();
//         const accountdb = await conn.query('SELECT is_private FROM users WHERE person_uid = ? LIMIT 1', [req.idPerson]);
//         if (accountdb[0][0].is_private == 1) {
//             await conn.query('UPDATE users SET is_private = ? WHERE person_uid = ?', [0, req.idPerson]);
//         }
//         else {
//             await conn.query('UPDATE users SET is_private = ? WHERE person_uid = ?', [1, req.idPerson]);
//         }
//         conn.end();
//         return res.json({
//             resp: true,
//             message: 'Account changed successfully',
//         });
//     }
//     catch (err) {
//         return res.status(500).json({
//             resp: false,
//             message: err
//         });
//     }
// };
// export const getSearchUser = async (req, res) => {
//     try {
//         const conn = await connect();
//         const userdb = await conn.query(`CALL SP_SEARCH_USERNAME(?);`, [req.params.username]);
//         conn.end();
//         return res.json({
//             resp: true,
//             message: 'User finded',
//             userFind: userdb[0][0]
//         });
//     }
//     catch (err) {
//         return res.status(500).json({
//             resp: false,
//             message: err
//         });
//     }
// };
// export const getAnotherUserById = async (req, res) => {
//     try {
//         const conn = await connect();
//         const [userdb] = await conn.query(`CALL SP_GET_USER_BY_ID(?);`, [req.params.idUser]);
//         const posters = await conn.query('  SELECT COUNT(person_uid) AS posters FROM posts WHERE person_uid = ?', [req.params.idUser]);
//         const friends = await conn.query('SELECT COUNT(person_uid) AS friends FROM friends WHERE person_uid = ?', [req.params.idUser]);
//         const followers = await conn.query('SELECT COUNT(person_uid) AS followers FROM followers WHERE person_uid = ?', [req.params.idUser]);
//         const posts = await conn.query(`CALL SP_GET_POST_BY_IDPERSON(?);`, [req.params.idUser]);
//         const isFollowing = await conn.query('CALL SP_IS_FRIEND(?,?);', [req.idPerson, req.params.idUser]);
//         const isPendingFollowers = await conn.query(`CALL SP_IS_PENDING_FOLLOWER(?,?)`, [req.params.idUser, req.idPerson]);
//         conn.end();
//         return res.json({
//             resp: true,
//             message: 'Get Another User by id',
//             anotherUser: userdb[0][0],
//             analytics: {
//                 'posters': posters[0][0].posters,
//                 'friends': friends[0][0].friends,
//                 'followers': followers[0][0].followers
//             },
//             postsUser: posts[0][0],
//             is_friend: isFollowing[0][0][0].is_friend,
//             isPendingFollowers: isPendingFollowers[0][0][0].is_pending_follower
//         });
//     }
//     catch (err) {
//         return res.status(500).json({
//             resp: false,
//             message: err
//         });
//     }
// };
// export const AddNewFollowing = async (req, res) => {
//     try {
//         const { uidFriend } = req.body;
//         const conn = await connect();
//         const isPrivateAccount = await conn.query('SELECT is_private FROM users WHERE person_uid = ?', [uidFriend]);
//         if (!isPrivateAccount[0][0].is_private) {
//             await conn.query('INSERT INTO friends (uid, person_uid, friend_uid) VALUE (?,?,?)', [uuidv4(), req.idPerson, uidFriend]);
//             await conn.query('INSERT INTO followers (uid, person_uid, followers_uid) VALUE (?,?,?)', [uuidv4(), uidFriend, req.idPerson]);
//             conn.end();
//             return res.json({
//                 resp: true,
//                 message: 'New friend'
//             });
//         }
//         await conn.query('INSERT INTO notifications (uid_notification, type_notification, user_uid, followers_uid) VALUE (?,?,?,?)', [uuidv4(), '1', uidFriend, req.idPerson]);
//         conn.end();
//         return res.json({
//             resp: true,
//             message: 'New friend'
//         });
//     }
//     catch (err) {
//         return res.status(500).json({
//             resp: false,
//             message: err
//         });
//     }
// };
// export const AcceptFollowerRequest = async (req, res) => {
//     try {
//         const { uidFriend, uidNotification } = req.body;
//         const conn = await connect();
//         await conn.query('INSERT INTO friends (uid, person_uid, friend_uid) VALUE (?,?,?)', [uuidv4(), uidFriend, req.idPerson]);
//         await conn.query('INSERT INTO followers (uid, person_uid, followers_uid) VALUE (?,?,?)', [uuidv4(), req.idPerson, uidFriend]);
//         await conn.query('UPDATE notifications SET type_notification = ? WHERE uid_notification = ?', ['3', uidNotification]);
//         conn.end();
//         return res.json({
//             resp: true,
//             message: 'New friend'
//         });
//     }
//     catch (err) {
//         return res.status(500).json({
//             resp: false,
//             message: err
//         });
//     }
// };
// export const deleteFollowing = async (req, res) => {
//     try {
//         const conn = await connect();
//         await conn.query('DELETE FROM friends WHERE person_uid = ? AND friend_uid = ?', [req.idPerson, req.params.idUser]);
//         await conn.query('DELETE FROM followers WHERE person_uid = ? AND followers_uid = ?', [req.params.idUser, req.idPerson]);
//         conn.end();
//         return res.json({
//             resp: true,
//             message: 'Deleted friend'
//         });
//     }
//     catch (err) {
//         return res.status(500).json({
//             resp: false,
//             message: err
//         });
//     }
// };
// export const getAllFollowings = async (req, res) => {
//     try {
//         const conn = await connect();
//         const followings = await conn.query(`CALL SP_GET_ALL_FOLLOWING(?);`, [req.idPerson]);
//         conn.end();
//         return res.json({
//             resp: true,
//             message: 'Get All Following',
//             followings: followings[0][0]
//         });
//     }
//     catch (err) {
//         return res.status(500).json({
//             resp: false,
//             message: err
//         });
//     }
// };
// export const getAllFollowers = async (req, res) => {
//     try {
//         const conn = await connect();
//         const followers = await conn.query(`CALL SP_GET_ALL_FOLLOWERS(?);`, [req.idPerson]);
//         conn.end();
//         return res.json({
//             resp: true,
//             message: 'Get All Following',
//             followers: followers[0][0]
//         });
//     }
//     catch (err) {
//         return res.status(500).json({
//             resp: false,
//             message: err
//         });
//     }
// };
// export const deleteFollowers = async (req, res) => {
//     try {
//         const conn = await connect();
//         await conn.query('DELETE FROM friends WHERE person_uid = ? AND friend_uid = ?', [req.params.idUser, req.idPerson]);
//         await conn.query('DELETE FROM followers WHERE person_uid = ? AND followers_uid = ?', [req.idPerson, req.params.idUser]);
//         await conn.query('DELETE FROM notifications WHERE type_notification = 3 AND user_uid = ? AND followers_uid = ?', [req.idPerson, req.params.idUser]);
//         conn.end();
//         return res.json({
//             resp: true,
//             message: 'Deleted friend'
//         });
//     }
//     catch (err) {
//         return res.status(500).json({
//             resp: false,
//             message: err
//         });
//     }
// };
// export const updateOnlineUser = async (uid) => {
//     const conn = await connect();
//     await conn.query('UPDATE users SET is_online = true WHERE person_uid = ?', [uid]);
//     conn.end();
// };
// export const updateOfflineUser = async (uid) => {
//     const conn = await connect();
//     await conn.query('UPDATE users SET is_online = false WHERE person_uid = ?', [uid]);
//     conn.end();
// };