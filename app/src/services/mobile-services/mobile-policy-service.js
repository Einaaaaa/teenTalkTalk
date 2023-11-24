var db = require('../../utils/db');
const { v4: uuidv4 } = require('uuid');
const path = require("path");
// const { v4: uuidv4 } = require('uuid');

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

exports.getAllPolicy = async function(req, res) {
    var conn;
    try {
        conn = await db.getConnection();
        // console.log('policy-service getAllPolicy db getConnection');

        var query;
        var sortOrderCode = req.params.sortOrderCode;
        // console.log(sortOrderCode);

        if (sortOrderCode === '0') {
            // 최신순으로 정렬
            query = "SELECT * FROM webdb.tb_policy ORDER BY board_idx DESC;";
        } else if (sortOrderCode === '1') {
            // 등록 순으로 정렬
            query = "SELECT * FROM webdb.tb_policy ORDER BY board_idx ASC;";
        } else if (sortOrderCode === '2') {
           // 스크랩 수 많은 순으로 정렬
           query = "SELECT * FROM webdb.tb_policy ORDER BY count_scraps DESC;";
        } else if (sortOrderCode === '3') {
            // 스크랩 수 적은 순으로 정렬
            query = "SELECT * FROM webdb.tb_policy ORDER BY count_scraps ASC;";
        } else if (sortOrderCode === '4') {
            // 마감일 순으로 정렬
            query = "SELECT * FROM webdb.tb_policy ORDER BY application_end_date ASC;";
        } else if (sortOrderCode === '5') {
            
            // 조회수 높은 순으로 정렬
            query = "SELECT * FROM webdb.tb_policy ORDER BY count_views DESC;";
        }  
        else if (sortOrderCode === '6') {
            // 조회수 낮은 순으로 정렬
           query = "SELECT * FROM webdb.tb_policy ORDER BY count_views ASC;";
        }  
        else {
            // 기본적으로 등록 순으로 정렬
            query = "SELECT * FROM webdb.tb_policy ORDER BY board_idx ASC;";
        }
        

        var rows = await conn.query(query); // 쿼리 실행
        // console.log(rows[0]);

        // console.log(rows);
        return rows;
    } catch(error) {
        console.log('policy-service getAllPolicy:'+error);
    } finally {
        if (conn) conn.release();
        // conn.release();
    }

}

exports.getPolicyById = async function(req, res) {
    var conn;
    try {
        conn = await db.getConnection();
        console.log('policy-service getPolicyById db getConnection');
        var policyId = req.params.policyId;
        
        query = 'SELECT * FROM webdb.tb_policy WHERE uid = ?';
        var rows = await conn.query(query, [policyId]); // 쿼리 실행
        console.log(rows[0]);
        return rows;
    } catch(error) {
        console.log('policy-service getPolicyById:'+error);
    } finally {
        if (conn) conn.release();
        // conn.release();
    }

}






exports.getSearchPolicy = async function(req, res) {
    // console.log('policy-service getSearchPolicy : ',req.params.searchValue);
    var conn;
    var searchValue = '%' + req.params.searchValue + '%';
    // var sortOrderCode = req.params.sortOrderCode;
    // console.log(sortOrderCode);
    // console.log('policy-service getSearchPolicy : ',searchValue);
    try {
        conn = await db.getConnection();
        console.log('policy-service getSearchPolicy db getConnection');
        var query = "SELECT * FROM webdb.tb_policy WHERE policy_name LIKE" + "'"+searchValue+"'"; //+ ";"; 

        // // // 정렬
        // if (sortOrderCode === '0') {
        //     // 최신순으로 정렬
        //     query += " ORDER BY board_idx DESC;";
        // } else if (sortOrderCode === '1') {
        //     // 조회수 높은 순으로 정렬
        //     query += " ORDER BY count_views DESC;";
        // } else if (sortOrderCode === '2') {
        //    // 조회수 낮은 순으로 정렬
        //    query += " ORDER BY count_views ASC;";
        // } else if (sortOrderCode === '3') {
        //     // 스크랩 수 많은 순으로 정렬
        //     query += " ORDER BY count_scraps DESC;";
        // } else if (sortOrderCode === '4') {
        //     // 스크랩 수 적은 순으로 정렬
        //     query += " ORDER BY count_scraps ASC;";
        // } else if (sortOrderCode === '5') {
        //     // 마감일 순으로 정렬
        //     query += " ORDER BY application_release_date ASC;";
        // } else if (sortOrderCode === '6') {
        //     // 등록 순으로 정렬
        //     query += " ORDER BY board_idx ASC;";
        // } else {
        //     // 기본적으로 등록 순으로 정렬
        //     query += " ORDER BY board_idx ASC;";
        // }
        var rows =  await conn.query(query); // 쿼리 실행
        // console.log('policy-service getSerachPolicy');
        return rows;
    } catch(error){
        console.log('policy-service getSearchPolicy:'+error);
    } finally {
        if (conn) conn.release();   
    }
}

// exports.getPolicyBySelect = async function(req, res){
//     var conn;
//     var institution_code_name = req.params.institutionCodeName;
//     var institution_code_detail = req.params.institutionCodeDetail;
//     var target_code_name = req.params.targetCodeName;
//     var target_code_detail = req.params.targetCodeDetail;
//     var field_code_name = req.params.fieldCodeName;
//     var field_code_detail = req.params.fieldCodeDetail;
//     var character_code_name = req.params.characterCodeName;
//     var character_code_detail = req.params.characterCodeDetail;
//     // console.log('policy-service getPolicyBySelect : ',code_name, code_detail);
//     try {
//         conn = await db.getConnection();
//         console.log('policy-service getSearchPolicy db getConnecton');
//         var query = "SELECT * FROM webdb.tb_policy WHERE " + institution_code_name + " = ? AND " + target_code_name + " = ? AND " + field_code_name + " = ? AND " + character_code_name + " = ?;";
//         var rows = await conn.query(query, [institution_code_detail, target_code_detail, field_code_detail, character_code_detail]);

//         // console.log(rows);
//         return rows;
//     } catch(error){
//         console.log('policy-service getSelectPolicy:'+error);
//     } finally {
//         conn.release();
//     }
// }

exports.getPolicyBySelect = async function(req, res){
    var conn;
    var institution_code_name = req.query.institutionCodeName;
    var institution_code_detail = req.query.institutionCodeDetail;
    var target_code_name = req.query.targetCodeName;
    var target_code_detail = req.query.targetCodeDetail;
    var field_code_name = req.query.fieldCodeName;
    var field_code_detail = req.query.fieldCodeDetail;
    var character_code_name = req.query.characterCodeName;
    var character_code_detail = req.query.characterCodeDetail;
    var sortOrderCode = req.query.sortOrderCode;


    // console.log(institution_code_name);
    // console.log(institution_code_detail);
    // console.log(target_code_name);
    // console.log(target_code_detail);
    // console.log(field_code_name);
    // console.log(field_code_detail);
    // console.log(character_code_name);
    // console.log(character_code_detail);

    try {
        conn = await db.getConnection();
        console.log('policy-service getPolicyBySelect db getConnecton');

        var query = "";
        var values = [];

        // 4개 선택
        if (institution_code_name && target_code_name && field_code_name && character_code_name) {
            query = "SELECT * FROM webdb.tb_policy WHERE " + institution_code_name + " = ? AND " + target_code_name + " = ? AND " + field_code_name + " = ? AND " + character_code_name + " = ?";
            values = [institution_code_detail, target_code_detail, field_code_detail, character_code_detail];
        } 
        // 3개 선택 - 운영 기관, 정책 대상, 정책 분야
        else if (institution_code_name && target_code_name && field_code_name) { // 3개 선택
            query = "SELECT * FROM webdb.tb_policy WHERE " + institution_code_name + " = ? AND " + target_code_name + " = ? AND " + field_code_name + " = ?";
            values = [institution_code_detail, target_code_detail, field_code_detail];
        }
        // 3개 선택 - 운영 기관, 정책 대상, 정책 성격
        else if (institution_code_name && target_code_name && character_code_name) { // 3개 선택
            query = "SELECT * FROM webdb.tb_policy WHERE " + institution_code_name + " = ? AND " + target_code_name + " = ? AND " + character_code_name + " = ?";
            values = [institution_code_detail, target_code_detail, character_code_detail];
        }
        // 3개 선택 - 운영 기관, 정책 분야, 정책 성격 
        else if (institution_code_name && field_code_name && character_code_name) { // 3개 선택
            query = "SELECT * FROM webdb.tb_policy WHERE " + institution_code_name + " = ? AND " + field_code_name + " = ? AND " + character_code_name + " = ?";
            values = [institution_code_detail, field_code_detail, character_code_detail];
        }
        // 3개 선택 - 정책 대상, 정책 분야, 정책 성격
        else if (target_code_name && field_code_name && character_code_name) { // 3개 선택
            query = "SELECT * FROM webdb.tb_policy WHERE " + target_code_name + " = ? AND " + field_code_name + " = ? AND " + character_code_name + " = ?";
            values = [target_code_detail, field_code_detail, character_code_detail];
        }
        // 2개 선택 - 운영 기관, 정책 대상
        else if (institution_code_name && target_code_name) { // 2개 선택
            query = "SELECT * FROM webdb.tb_policy WHERE " + institution_code_name + " = ? AND " + target_code_name + " = ?";
            values = [institution_code_detail, target_code_detail];
        }
        // 2개 선택 - 운영 기관, 정책 분야
        else if (institution_code_name && field_code_name) { // 2개 선택
            query = "SELECT * FROM webdb.tb_policy WHERE " + institution_code_name + " = ? AND " + field_code_name + " = ?";
            values = [institution_code_detail, field_code_detail];
        }
        // 2개 선택 - 운영 기관, 정책 성격
        else if (institution_code_name && character_code_name) { // 2개 선택
            query = "SELECT * FROM webdb.tb_policy WHERE " + institution_code_name + " = ? AND " + character_code_name + " = ?";
            values = [institution_code_detail, character_code_detail];
        }
        // 2개 선택 - 정책 대상, 정책 분야
        else if (target_code_name && field_code_name) { // 2개 선택
            query = "SELECT * FROM webdb.tb_policy WHERE " + target_code_name + " = ? AND " + field_code_name + " = ?";
            values = [target_code_detail, field_code_detail];
        }
        // 2개 선택 - 정책 대상, 정책 성격
        else if (target_code_name && character_code_name) { // 2개 선택
            query = "SELECT * FROM webdb.tb_policy WHERE " + target_code_name + " = ? AND " + character_code_name + " = ?";
            values = [target_code_detail, character_code_detail];
        }
        // 2개 선택 - 정책 분야, 정책 성격
        else if (field_code_name && character_code_name) { // 2개 선택
            query = "SELECT * FROM webdb.tb_policy WHERE " + field_code_name + " = ? AND " + character_code_name + " = ?";
            values = [field_code_detail, character_code_detail];
        } 
        // 1개 선택 - 운영 기관
        else if (institution_code_name) { // 1개 선택
            query = "SELECT * FROM webdb.tb_policy WHERE " + institution_code_name + " = ?";
            values = [institution_code_detail];
        }
        // 1개 선택 - 정책 대상
        else if (target_code_name) { // 1개 선택
            query = "SELECT * FROM webdb.tb_policy WHERE " + target_code_name + " = ?";
            values = [target_code_detail];
        }
        // 1개 선택 - 정책 분야
        else if (field_code_name) { // 1개 선택
            query = "SELECT * FROM webdb.tb_policy WHERE " + field_code_name + " = ?";
            values = [field_code_detail];
        }
        // 1개 선택 - 정책 성격
        else if (character_code_name) { // 1개 선택
            query = "SELECT * FROM webdb.tb_policy WHERE " + character_code_name + " = ?";
            values = [character_code_detail];
        } 

        // else { // 선택된 조건이 없을 경우
        //     return { success: false, message: "At least one search condition must be selected." };
        // }

        // 정렬
        if (sortOrderCode === '0') {
            // 최신순으로 정렬
            query += " ORDER BY board_idx DESC;";
        } else if (sortOrderCode === '1') {
            // 조회수 높은 순으로 정렬
            query += " ORDER BY count_views DESC;";
        } else if (sortOrderCode === '2') {
           // 조회수 낮은 순으로 정렬
           query += " ORDER BY count_views ASC;";
        } else if (sortOrderCode === '3') {
            // 스크랩 수 많은 순으로 정렬
            query += " ORDER BY count_scraps DESC;";
        } else if (sortOrderCode === '4') {
            // 스크랩 수 적은 순으로 정렬
            query += " ORDER BY count_scraps ASC;";
        } else if (sortOrderCode === '5') {
            // 마감일 순으로 정렬
            query += " ORDER BY application_end_date ASC;";
        } else if (sortOrderCode === '6') {
            // 등록 순으로 정렬
            query += " ORDER BY board_idx ASC;";
        } else {
            // 기본적으로 등록 순으로 정렬
            query += " ORDER BY board_idx ASC;";
        }

        // console.log('policy-service getSelectPolicy query:', query, ' values:', values);

        const rows = await conn.query(query, values);
        // console.log('policy-service getSearchPolicy rows:', rows);
        return rows;
        
    }

    catch(error){
        console.log('policy-service getSelectPolicy:'+error);
    } finally {
        if (conn) conn.release();   
    }
}


exports.getAllPolicyForSearch = async function(req, res) {
    var conn;
    try{
        conn = await db.getConnection();
        console.log('policy-service getAllPolicyForSearch db getConnection');
        var query = "SELECT * FROM webdb.tb_policy;";
        var rows = await conn.query(query); // 쿼리 실행
        // console.log(rows[0]);
        // console.log(rows[1]);
        // console.log(rows[2]); 
        return rows;
    } catch(error) {
        console.log('policy-service getAllPolicyForSearch:'+error);
    } finally {
        if (conn) conn.release();   
    }
}


exports.scrapOrUnscrapPolicy = async function(req, res) {
    // console.log('policy_service scrapOrUnscrapPolicy', req.body);
    var resultcode = 0; // scrap
    try{

        const { uidPolicy, uidUser } = req.body;
        const conn = await db.getConnection();
        // console.log('policy-service scrapOrUnscrapPolicy db getConnection');
        const isScrapdb = await conn.query('SELECT COUNT(uid_scraps) AS uid_scraps FROM webdb.tb_policy_scrap WHERE user_uid = ? AND policy_uid = ? LIMIT 1', [req.idPerson, uidPolicy]);

        // console.log(isScrapdb[0]);

        //스크랩취소(unscrap)
        if (isScrapdb[0].uid_scraps > 0) {
            await conn.query('DELETE FROM webdb.tb_policy_scrap WHERE user_uid = ? AND policy_uid = ?', [req.idPerson, uidPolicy]);
            await conn.query('UPDATE webdb.tb_policy SET count_scraps = count_scraps - 1 WHERE uid = ?', [uidPolicy]);
            await conn.query('UPDATE webdb.tb_policy_scrap INNER JOIN webdb.tb_policy ON webdb.tb_policy_scrap.policy_uid = webdb.tb_policy.uid SET is_scrapped = 0 WHERE policy_uid = ?', [uidPolicy]);



            conn.release();
            resultcode = 1; // unscrap
        return resultcode; //res.status(200).json({ resultcode });
        }

  
        await conn.query('INSERT INTO webdb.tb_policy_scrap (uid_scraps, user_uid, policy_uid) VALUE (?,?,?)', [uuidv4(), req.idPerson, uidPolicy]);
        await conn.query('UPDATE webdb.tb_policy SET count_scraps = count_scraps + 1 WHERE uid = ?', [uidPolicy]);
        await conn.query('UPDATE webdb.tb_policy_scrap INNER JOIN webdb.tb_policy ON tb_policy_scrap.policy_uid = tb_policy.uid SET is_scrapped = 1 WHERE policy_uid = ?', [uidPolicy]);
       


        conn.release();
        return resultcode; //res.status(200).json({ resultcode });
  
    } catch(error) {

        console.log('policy-service scrapOrUnscrapPolicy:'+error);
        return res.status(500).json({ error });
    }
  };
  
    exports.getScrappedPolicy = async function(req, res) {
    var conn;
    try{
        conn = await db.getConnection();
        // console.log('policy-service getScappedPolicy db getConnection');
        // console.log(req.idPerson);
        const policydb = await conn.query(`CALL webdb.SP_GET_SCRAPPED_POLICY(?);`, [req.idPerson]);
        // console.log(policydb[0]);
        
        return policydb[0];
    } catch(error) {
        console.log('policy-service getScappedPolicy:'+error);
    } finally {
        if (conn) conn.release();   
    }
    };

    exports.checkPolicyScrapped = async function(req, res) {
        var conn;
        try {
            conn = await db.getConnection();
            // console.log('policy-service checkPolicyScrapped db getConnection');
            const uidPolicy = req.params.uidPolicy;
            const uidUser = req.idPerson;
            const query = `SELECT IFNULL(is_scrapped, 0) AS isScrapped FROM webdb.tb_policy_scrap WHERE user_uid = (?) AND policy_uid = (?);`;
            const result = await conn.query(query, [uidUser, uidPolicy]);
    
            const isScrapped = result[0]?.isScrapped || 0;
            // console.log(isScrapped);
            return {
                isScrapped: isScrapped == 1 ? 1 : 0
            };
        
        } catch(error){
            console.log('policy-service checkPolicyScrapped:'+error);
            return {
                resp: false,
                error: error.message,
                isScrapped : 0
            };
        } finally {
            if (conn) conn.release();   
        }
    };

    
    


