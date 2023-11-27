var db = require('../utils/db');
// var s_db = require('../utils/s_db');
var bkfd2Password = require('pbkdf2-password');
var hasher = bkfd2Password();
const url = require('url');
// const { uuid } = require('uuidv4');
const { v4: uuidv4 } = require('uuid');
var utils = require('../utils/utils');
var fs = require('fs');


exports.fetchEventPart = async function (req, res) {
    try{
        conn = await db.getConnection();
        var query = 'SELECT uid,userid,event_part,reg_no,user_name,user_role,user_type,youthAge_code,parentsAge_code,sex_class_code,emd_class_code,user_email,fig,ins_date,upd_date FROM webdb.tb_user where event_part = 1 order by ins_date desc';
        var rows = await conn.query(query); // 쿼리 실행
        return rows;
    }
    catch(error){
        console.log('event-service fetchEventPart error: ' + error);
    }
    finally{
        conn.release();
    }
};