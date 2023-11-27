var db = require('../../utils/db');


// 무화과 지급(이벤트 참여)
// tb_event_part에 기록 추가, tb_user의 fig열 update
exports.giveFigForAttendance = async function(req, res) {
  var conn;
  try{
    conn = await db.getConnection();
    // var eid = req.params.eid;
    var uid = req.idPerson;
    var query = `CALL webdb.SP_GIVE_FIG_FOR_ATTENDANCE(?)`;
    var result = await conn.query(query, [uid]);
    // console.log(result);
    return result


  } catch(error) {
    console.log('mobile-event-service giveFig:'+error);
  } finally {
    if(conn) conn.release();
  }
};

// 출석체크 기록 가져오기
// tb_attendance_log에서 uid로 날짜 return -> frontrelease에서 day 리스트로 받아 temp_days에 저장
exports.getAttendance = async function(req, res) {
  var resultcode = 0;
  var conn;
  try{
    conn = await db.getConnection();
    var uid = req.idPerson;
    
    // uid를 통해 출석기록 받아오기
    // var query = 'SELECT * FROM webdb.tb_attendance_logs WHERE user_uid = "' + uid + '"';
    var query = 'SELECT DATE_FORMAT(attendance_date, "%Y-%m-%d") AS attendance_date FROM webdb.tb_attendance_logs WHERE user_uid = "' + uid + '"';
    var attendanceLog = await conn.query(query); // 쿼리 실행
    // console.log(attendanceLog);

    if(attendanceLog.length){
      resultcode = 1;
    } else resultcode = 0;
    return attendanceLog;
  } catch(error) {
    console.log('mobile-event-service getAttendance:'+error);
  } finally {
    if(conn) conn.release();
  }
  return resultcode;
};

// 무화과 지급 - 친구초대
exports.giveFigForInvitation = async function(req, res) {
  var conn;
  var resultcode = 0;
  try {
    conn = await db.getConnection();
    var invite_code = req.body.invite_code;
    var invitee_uid = req.idPerson;
    var query = `CALL webdb.SP_GIVE_FIG_FOR_INVITATION(?,?)`;
    var rows = await conn.query(query, [invitee_uid, invite_code]);
    // console.log(rows);
    // console.log(rows[0][0].code_valid);
   
    
    if (rows[0][0].code_valid == 1) {
      resultcode = 1;// 유효한 코드
    } 
    
    
    return resultcode;
  } catch(error) {
    console.log('mobile-event-service giveFigForInvitation:'+error);
    return 'error';
  } finally {
    if(conn) conn.release();
  }
};

// 가입 24시간 이내 여부 확인
exports.checkUserWithin24Hours = async function(req, res){
  var conn;
  try {
    conn = await db.getConnection();
    var uid =req.idPerson;
    var query = 'SELECT ins_date FROM webdb.tb_user WHERE uid = ?';
    var userData = await conn.query(query, [uid]);
    var insDate = userData[0].ins_date;
    // console.log(insDate);
    var currreleaseDate = new Date();
    // console.log(currreleaseDate);
// 
    // 가입일과 현지 시각 비교
    var isWithin24Hours = (currreleaseDate - insDate) < (24 * 60 * 60 * 1000); // 단위 : 밀리초
    // console.log(isWithin24Hours);
    return isWithin24Hours;

  } catch(error){
    console.log('mobile-event-service checkUserWithin24Hours: ' + error);
    return false;
  } finally {
    if(conn) conn.release();
  }
};


// 무화과 지급 - 주간 무화과 챌린지
exports.giveFigForWeeklyFigChallenge = async function(req, res) {
  var conn;
  try{
    conn = await db.getConnection();
    var eid = req.body.eid;
    var uid = req.idPerson;
    var query = `CALL webdb.SP_GIVE_FIG_FOR_WEEKLY_FIG_CHALLENGE(?,?)`;
    var result = await conn.query(query, [uid, eid]);
    // console.log(result);
    return result


  } catch(error) {
    console.log('mobile-event-service giveFig:'+error);
  } finally {
    if(conn) conn.release();
  }
};

// 이벤트 참여 내역 확인
exports.checkEventParticipation = async function(req, rese) {
  var conn;
  try {
    conn = await db.getConnection();
    var uid = req.idPerson;
    var eid = req.params.eid;
    var query = `SELECT COUNT(*) AS count FROM webdb.tb_event_part WHERE uid = ? AND eid = ?`;
    var rows = await conn.query(query, [uid, eid]);
    var result = rows[0].count;
    // console.log(rows);
    // console.log(rows[0].count);

    // if(rows && rows[0].count > 0) {
    //   result = false;// 참여 내역 있음
    // } 

    return result;

  } catch(error){
    console.log('mobile-event-service checkEventParticipation:'+error);
    return 'error';
  } finally {
    if(conn) conn.release();
  }
};





// 무화과 사용 내역 가져오기
exports.fetchFigUsageByUser = async function(req, res) {
    var conn;
    try{
      conn = await db.getConnection();
      var uid = req.idPerson;
      // query = 'SELECT * FROM webdb.tb_fig_usage where uid="'+uid[0].uid+'"';
      query = 'select fig_usage_no,fig_used_date,product_name,product_cost,product_stock from webdb.tb_fig_usage as a inner join webdb.tb_product as b on a.pid = b.pid where a.uid = "'+uid+'";'
      rows = await conn.query(query); // 쿼리 실행
      return rows;
    } catch(error) {
      console.log('mobile-event-service fetchFigUsageByUser:'+error);
    } finally {
      if (conn) conn.release();
    }
  };

// 무화과 지급 내역(이벤트 참여 내역) 가져오기
exports.fetchFigRewardByUser = async function(req, res) {
  var conn;
  try{
    conn = await db.getConnection();
    var uid = req.idPerson;
    query = 'select event_part_no,acquired_time,event_name,fig_payment from webdb.tb_event_part as a inner join webdb.tb_event as b on a.eid = b.eid where a.uid ="'+uid+'"'; 
    var rows = await conn.query(query); // 쿼리 실행
    // console.log(rows);
    return rows;
  } catch(error) {
    console.log('mobile-event-service fetchFigRewardByUser:'+error);
  } finally {
    if (conn) conn.release();
  }
};

// 이벤트 참여
exports.participateEvent = async function(req, res) {
  var conn;
  var resultcode = 0; // 0: 참여 실패, 1: 참여 성공
  try{
    conn = await db.getConnection();
    var uid = req.params.uid;
    // 사용자가 이벤트 참여 이력이 있는 지 확인
    var query = 'SELECT event_part FROM webdb.tb_user WHERE uid = ?';
    var event_part = await conn.query(query, [uid]);
    if(event_part[0].event_part == 0) { // 이벤트 참여 이력 없음
      // 이벤트 참여
      var query = 'UPDATE webdb.tb_user SET event_part = 1 WHERE uid = ?';
      var result = await conn.query(query, [uid]);
      // console.log(result);
      resultcode = 1;
      return resultcode;
    }
    // console.log(result);
    return resultcode;
  } catch(error) {
    console.log('mobile-event-service participateEvent:'+error);
  }
}