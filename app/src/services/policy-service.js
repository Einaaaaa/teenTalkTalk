var db = require('../utils/db');
var multer = require('multer');
const path = require("path");
var fs = require("fs");
// const { uuid } = require('uuidv4');
const { v4: uuidv4 } = require('uuid');

exports.fetchData = async function(req, res) {
    var conn;
    try{
        conn = await db.getConnection();
        console.log('policy-service fetchData db getConnection');
        var query = "SELECT * FROM webdb.tb_policy;";
        var rows = await conn.query(query); // 쿼리 실행
        return rows;
    } catch(error) {
        console.log('policy-service fetchData:'+error);
    } finally {
        conn.release();
    }
};

//policy-upload창에서 필요한 코드 정보들 가져오기
exports.fetchCodeData = async function(req, res) {
    var conn;
    try{
        conn = await db.getConnection();
        console.log('policy-service fetchCodeData db getConnection');
        var query = "SELECT * FROM webdb.tb_policy_target_code,tb_policy_institution_code except  board_idx;";
        var rows = await conn.query(query); // 쿼리 실행
        return rows;
    } catch(error) {
        console.log('policy-service fetchCodeData:'+error);
    } finally {
        conn.release();
    }
};

exports.fetchpolicyByidx = async function(req, res) {
    var conn;
    try{
      conn = await db.getConnection();
      var query = 'SELECT * FROM webdb.tb_policy where board_idx="'+req.params.id+'"';
      var rows = await conn.query(query); // 쿼리 실행
      return rows;
    } catch(error) {
      console.log('dataif-service fetchpolicyByidx:'+error);
    } finally {
      if (conn) conn.release();
    }
  };

exports.updatePolicy = async function(req, res) {
    var conn;
    var resultcode = 0;
    try{
        //form data 받아오기
        var temp = Date.now();
        // 이미지 업로드
        var upload = multer({ 
            storage: multer.diskStorage({
                destination: function (req, file, cb) {
                    // cb(null, '../frontend/images/policy');
                    cb(null, './src/public/upload/policy'); //../app/src/public/upload/policy
                },
                filename: function (req, file, cb) {
                    temp = temp + path.extname(file.originalname);
                    cb(null, temp);
                }
            })
        }).single('imgFile');
        upload(req, res, function (err) {
            if (err instanceof multer.MulterError) {
                console.log('multer error:' + err);
            } else if (err) {
                console.log('multer error:' + err);
            }
        });
        // DB에 저장
        conn = await db.getConnection();
        console.log('policy-service updatePolicy db getConnection');
        var query;
        // imgCheck가 on상태라면 기존 이미지를 그대로 사용하고, off라면 새로운 이미지를 사용한다.
        const uidPolicy = uuidv4(); // 정책 고유 번호
        if(req.body.imgCheck == 'on') {
            query = "update webdb.tb_policy set uid = '"+uidPolicy+"', policy_name='"+req.body.name+"', content='"+req.body.content+"', min_fund='"+req.body.min_fund+"', max_fund='"+req.body.max_fund+"', policy_target_code='"+req.body.target+"', policy_institution_code='"+req.body.policy_institution_code+"', application_start_date='"+req.body.application_start_date+"', application_end_date='"+req.body.application_end_date+"', policy_field_code='"+req.body.policy_field_code+"', policy_character_code='"+req.body.policy_character_code+"', policy_institution_code='"+req.body.policy_institution_code+"' where board_idx='"+req.params.id+"';";
        }
        else {
            var policy_img = await conn.query("select img from webdb.tb_policy where board_idx='"+req.params.id+"';");
            query = "UPDATE webdb.tb_policy SET uid = '"+uidPolicy+"', img='"+temp+"', policy_name='"+req.body.name+"', content='"+req.body.content+"', min_fund='"+req.body.min_fund+"', max_fund='"+req.body.max_fund+"', policy_target_code='"+req.body.target+"', policy_institution_code='"+req.body.policy_institution_code+"', application_start_date='"+req.body.application_start_date+"', application_end_date='"+req.body.application_end_date+"', policy_field_code='"+req.body.policy_field_code+"', policy_character_code='"+req.body.policy_character_code+"', policy_institution_code='"+req.body.policy_institution_code+"' where board_idx='"+req.params.id+"';";
            var imagePath = './src/public/upload/policy/'+policy_img[0].img;
            fs.access(imagePath, fs.constants.F_OK, function (err) {
                if (!err) {
                    fs.unlink(imagePath, function (err) { //정책 이미지 삭제
                        if (err) throw err;
                        console.log('file deleted');
                    });
                } else {
                    console.log('no file');
                }
            });
        }
        var rows = await conn.query(query); // 쿼리 실행
        return resultcode;
    } catch(error) {
        console.log('policy-service updatePolicy:'+error);
        resultcode = 1;
    } finally {
        conn.release();
    }
};

exports.deletePolicy = async function(req, res) {
    var conn;
    try{
        conn = await db.getConnection();
        console.log('policy-service deletePolicy db getConnection');
        var policy_uid = await conn.query("select uid from webdb.tb_policy where board_idx='"+req.params.id+"';");
        var policy_uid = policy_uid[0].uid;
        var query = "DELETE FROM webdb.tb_policy_scrap where policy_uid='"+policy_uid+"';";
        var rows = await conn.query(query);
        query = "DELETE FROM webdb.tb_policy where board_idx='"+req.params.id+"';";
        rows = await conn.query(query); // 쿼리 실행
        //삭제가 제대로 되었는 지 확인
        query = "SELECT * FROM webdb.tb_policy where board_idx='"+req.params.id+"';";
        rows = await conn.query(query); // 쿼리 실행
        if(rows.length == 0) {
            console.log('policy-service deletePolicy success');
            return 0;
        }
        else {
            console.log('policy-service deletePolicy fail');
            return 1;
        }
    } catch(error) {
        console.log('policy-service deletePolicy:'+error);
    } finally {
        conn.release();
    }
};

exports.fetchpolicyImgByidx = async function(req, res) {
    var conn;
    try{
        conn = await db.getConnection();
        console.log('policy-service fetchpolicyImgByidx db getConnection');
        var query = "SELECT img FROM webdb.tb_policy where board_idx='"+req.params.id+"';";
        var rows = await conn.query(query); // 쿼리 실행
        return rows;
    } catch(error) {
        console.log('policy-service fetchpolicyImgByidx:'+error);
    } finally {
        conn.release();
    }
};

exports.upload = async function(req, res) {
    var conn;
    var resultcode = 0;
    try{
        var temp = Date.now();
        // 이미지 업로드
        var upload = multer({ 
            storage: multer.diskStorage({
                destination: function (req, file, cb) {
                    cb(null, './src/public/upload/policy'); //../app/src/public/upload/policy
                },
                filename: function (req, file, cb) {
                    temp = temp + path.extname(file.originalname);
                    cb(null, temp);
                }
            })
        }).single('imgFile');
        upload(req, res, function (err) {
            if (err instanceof multer.MulterError) {
                console.log('multer error:' + err);
            } else if (err) {
                console.log('multer error:' + err);
            }
        });
        // DB에 저장
        conn = await db.getConnection();
        console.log('policy-service upload db getConnection');
        console.log(req.body);
        var { name, target, policy_institution_code, min_fund, max_fund, content, application_start_date, application_end_date, 
            policy_field_code, policy_character_code, policy_link } = req.body; 
        if (!name) return 1; 
        if (!min_fund) return 3;
        if (!max_fund) return 4;
        if (!application_start_date) return 5;
        if (!application_end_date) return 6;             
        // register_uid 받아오기
        register_userid = req.session.user.data.userid; 
        register_uid = await conn.query("select uid from webdb.tb_user where userid='"+register_userid+"';");
        register_uid = register_uid[0].uid;
        const uidPolicy = uuidv4(); // 정책 고유 번호
        var query = "INSERT INTO webdb.tb_policy (uid, policy_name, policy_target_code, policy_institution_code, min_fund, max_fund, content, img, application_start_date, application_end_date, policy_field_code, policy_character_code, policy_link, register_uid) VALUES "
          + "('"+uidPolicy+"', '" + name + "', '" + target + "', '" + policy_institution_code + "', '" + min_fund + "', '" + max_fund + "', '" + content + "', '" + temp + "', '" + application_start_date + "', '" + application_end_date + "', '" + policy_field_code + "', '" + policy_character_code + "', '" + policy_link + "', '" + register_uid + "');";
        var rows = await conn.query(query); // 쿼리 실행
        console.log('policy-service upload success');
        return resultcode; //0이면 성공
    } catch(error) {
        console.log('policy-service upload:'+error);
        resultcode = 100;
    } finally {
        if (conn) conn.release();
    }
};



exports.banner = async function(req, res) {
    var conn;
    var resultcode = 0;
    try{
        // 베너의 개수가 6개 이상이면 업로드 불가
        conn = await db.getConnection();
        console.log('policy-service banner db getConnection');
        var query = "SELECT count(*) as cnt FROM webdb.tb_banner;";
        var banner_count = await conn.query(query); // 쿼리 실행
        if(banner_count[0].cnt >= 6) {
            resultcode = 1;
            return resultcode;
        }
        var temp = Date.now();
        // 이미지 업로드
        var upload = multer({ 
            storage: multer.diskStorage({
                destination: function (req, file, cb) {
                    // cb(null, '../frontend/images/banner');
                    cb(null, './src/public/upload/banner');
                },
                filename: function (req, file, cb) {
                    temp = temp + path.extname(file.originalname);
                    cb(null, temp);
                }
            })
        }).single('imgFile');
        upload(req, res, function (err) {
            if (err instanceof multer.MulterError) {
                console.log('multer error:' + err);
            } else if (err) {
                console.log('multer error:' + err);
            }
        });
        conn = await db.getConnection();
        console.log('policy-service banner db getConnection:', req.body);
        // console.log(req.body);
        var name = req.body.name;
        var link = req.body.link;
        var query = "INSERT INTO webdb.tb_banner (banner_name, banner_img, banner_link) VALUES ('" + name + "', '" + temp + "', '" + link + "');";
        var rows = await conn.query(query); // 쿼리 실행
        console.log('policy-service banner success');
        return resultcode; //0이면 성공
    } catch(error) {
        console.log('policy-service banner:'+error);
        resultcode = 100;
    } finally {
        if (conn) conn.release();
    }
};

exports.fetchBannerData = async function(req, res) {
    var conn;
    try{
        conn = await db.getConnection();
        console.log('policy-service fetchBannerData db getConnection');
        var query = "SELECT * FROM webdb.tb_banner;";
        var rows = await conn.query(query); // 쿼리 실행
        return rows;
    } catch(error) {
        console.log('policy-service fetchBannerData:'+error);
    } finally {
        conn.release();
    }
};

exports.deleteBanner = async function(req, res) {
    var conn;
    var resultcode = 0;
    try{
        conn = await db.getConnection();
        var query = 'delete from webdb.tb_banner where board_idx="'+req.params.id+'"';
        var rows =  await conn.query(query); // 쿼리 실행
        console.log('policy-service deleteBanner success');
        return resultcode; //0이면 성공
    } catch(error) {
        console.log('policy-service deleteBanner:'+error);
        resultcode = 100;
    } finally {
        conn.release();
    }
};

exports.fetchBannerImg = async function(req, res) {
    var conn;
    try{
        conn = await db.getConnection();
        console.log('policy-service fetchBannerImg db getConnection');
        var query = "SELECT banner_img FROM webdb.tb_banner where board_idx = '" + req.params.id + "';";
        var rows = await conn.query(query); // 쿼리 실행
        return rows;
    } catch(error) {
        console.log('policy-service fetchBannerImg:'+error);
    } finally {
        conn.release();
    }
};

exports.regTest = async function(req, res) {
    var conn;
    try{
        conn = await db.getConnection();
        console.log('policy-service regTest db getConnection');     
        const uidPolicy = uuidv4(); // 정책 고유 번호
        // 정책 임의 등록
        var query = "INSERT INTO webdb.tb_policy (uid, policy_name, policy_target_code, policy_institution_code, min_fund, max_fund, content, img, application_start_date, application_end_date, policy_field_code, policy_character_code, policy_link) VALUES ('"+uidPolicy+"', 'name1', '00', '00', '1000', '10000', 'content1', 'img1.png', '2020-01-01', '2020-01-01', '01', '01', 'link1');";
        var rows = await conn.query(query); // 쿼리 실행
        console.log('policy-service regTest success');
        return rows;
    } catch(error) {
        console.log('policy-service regTest:'+error);
    } finally {
        conn.release();
    }
};

exports.fetchpolicy = async function(req, res) {
    var conn;
    try{
        conn = await db.getConnection();
        console.log('policy-service fetchpolicy db getConnection');
        var query = "SELECT * FROM webdb.tb_policy;";
        var rows = await conn.query(query); // 쿼리 실행
        return rows;
    } catch(error) {
        console.log('policy-service fetchpolicy:'+error);
    } finally {
        conn.release();
    }
};

// mobile-service
// exports.getAllPolicy = async function(req, res) {
//     var conn;
//     try{
//         conn = await db.getConnection();
//         console.log('policy-service getAllPolicy db getConnection');
//         var query = "SELECT * FROM webdb.tb_policy;";
//         var rows = await conn.query(query); // 쿼리 실행
//         // console.log(rows[0]);

//         // console.log(rows);
//         return rows;
//     } catch(error) {
//         console.log('policy-service getAllPolicy:'+error);
//     } finally {
//         conn.release();
//     }
// }





// exports.getSearchPolicy = async function(req, res) {
//     // console.log('policy-service getSearchPolicy : ',req.params.searchValue);
//     var conn;
//     var searchValue = '%' + req.params.searchValue + '%';
//     // console.log('policy-service getSearchPolicy : ',searchValue);
//     try {
//         conn = await db.getConnection();
//         console.log('policy-service getSearchPolicy db getConnection');
//         var query = "SELECT * FROM webdb.tb_policy WHERE policy_name LIKE" + "'"+searchValue+"'" + ";"; 
//         var rows =  await conn.query(query); // 쿼리 실행
//         // console.log('policy-service getSerachPolicy success');
//         return rows;
//     } catch(error){
//         console.log('policy-service getSearchPolicy:'+error);
//     } finally {
//         conn.release();
//     }
// }
// exports.getPolicyBySelect = async function(req, res){
//     var conn;
//     var code = req.params.code;
//     // console.log('policy-service getPolicyBySelect : ',code);
//     try {
//         conn = await db.getConnection();
//         console.log('policy-service getSearchPolicy db getConnecton');
//         var query = "SELECT * FROM webdb.tb_policy WHERE policy_field_code = " + "'"+code+"'" + ";"; 
//         var rows =  await conn.query(query); // 쿼리 실행
//         // console.log('policy-service getSelectPolicy success');
//         return rows;
//     } catch(error){
//         console.log('policy-service getSelectPolicy:'+error);
//     } finally {
//         conn.release();
//     }
// }

// exports.getAllPolicyForSearch = async function(req, res) {
//     var conn;
//     try{
//         conn = await db.getConnection();
//         console.log('policy-service getAllPolicyForSearch db getConnection');
//         var query = "SELECT * FROM webdb.tb_policy;";
//         var rows = await conn.query(query); // 쿼리 실행
//         // console.log(rows[0]);
//         // console.log(rows[1]);
//         // console.log(rows[2]); 
//         return rows;
//     } catch(error) {
//         console.log('policy-service getAllPolicyForSearch:'+error);
//     } finally {
//         conn.release();
//     }
// }

// exports.getBannerData = async function(req, res) {
//     var conn;
//     try{
//         conn = await db.getConnection();
//         console.log('policy-service getBannerData db getConnection');
//         var query = "SELECT banner_name, banner_img, banner_link FROM webdb.tb_banner;";
//         var rows = await conn.query(query); // 쿼리 실행
//         // console.log(rows);
//         return rows;
//     } catch(error) {
//         console.log('policy-service fetchBannerData:'+error);
//     } finally {
//         conn.release();
//     }
// };

// exports.scrapOrUnscrapPolicy = async function(req, res) {
//     console.log('policy_service scrapOrUnscrapPolicy', req.body);
//     var resultcode = 0;
//     try{
//         const {uidPolicy, uidUser} = req.body;
//         const conn = await db.getConnection();
//         console.log('policy-service scrapOrUnscrapPolicy db getConnection');

//         const isScrapdb = await conn.query('SELECT COUNT(uid_scraps) AS uid_scraps FROM webdb.tb_policy_scrap WHERE user_uid = ? AND policy_uid = ? LIMIT 1', [req.idPerson, uidPolicy]);
        
//         if(isScrapdb[0][0].uid_scraps > 0) {
//             await conn.query('DELETE FROM webdb.tb_policy_scrap WHERE user_uid = ? AND policy_uid = ?', [req.idPerson, uidPolicy]);
//             conn.end();
//             resultcode = 1; // unscrap
//             return resultcode;
//         }
//         await conn.query('INSERT INTO webdb.tb_policy_scrap (uid_scraps, user_uid, policy_uid) VALUE (?,?,?)', [uuidv4(), req.idPerson, uidPolicy]);
//         conn.end();
//         return resultcode;



//         // var query = "update  webdb.tb_policy set count_scrps = count_scraps+1 where board_idx = 1;";
//         // var rows = await conn.query(query); // 쿼리 실행
//         // // console.log(rows);
//         // return rows;
//     } catch(error) {
//         console.log('policy-service scrapOrUnscrapPolicy:'+error);
//     } finally {
//         conn.release();
//     }
// };

