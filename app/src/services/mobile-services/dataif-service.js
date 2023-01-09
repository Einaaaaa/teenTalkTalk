var db = require('../../utils/db');
var s_db = require('../../utils/s_db');
var bkfd2Password = require('pbkdf2-password');
var hasher = bkfd2Password();
var utils = require('../../utils/utils');
var fs = require('fs');

exports.fetchData = async function(req, res) {
  var conn;
  try{
    conn = await db.getConnection();

    var start = 0;
    var page=0;
    var pageSize=10;
    var reqpage=req.query.page;
    var reqpageSize=req.query.pageSize;
    var reqsrchword=req.query.srchword;
    if(reqpage!=undefined) page=reqpage;
    if(reqpageSize!=undefined) pageSize=reqpageSize;
    if (page <= 0) page = 1;
    else start = (page - 1) * pageSize;
    var query = 'SELECT count(*) cnt FROM webdb.tb_dataif a inner join webdb.tb_sensor b on a.sensor_board_idx=b.board_idx left outer join webdb.tb_file c'
                +' on c.board_type="tb_dataif" and c.board_idx=a.board_idx where a.ins_id="'+req.user.userid+'"';
    var rows = await conn.query(query);
    var totalPages=Math.ceil(rows[0].cnt / pageSize);
    if (page > totalPages) {
      var rtn=[];
      rtn.totalPages=totalPages;
      rtn.page=page;
      return rtn;
    }

    query = `SELECT a.*, sen_mng_no, file_type, file_no, board_type, `
                +`case when permit_type="N" then "사용자요청" when permit_type="U" then "소유자허가" when permit_type="Y" then "연계준비중" when permit_type="S" then "연계중" when permit_type="E" then "연계완료" end permit_type_nm`
                +` FROM webdb.tb_dataif a inner join webdb.tb_sensor b on a.sensor_board_idx=b.board_idx left outer join webdb.tb_file c`
                +` on c.board_type="tb_dataif" and c.board_idx=a.board_idx where a.ins_id="${req.user.userid}" order by a.board_idx desc LIMIT ${start}, ${pageSize}`;
    rows = await conn.query(query); // 쿼리 실행

    rows.totalPages=totalPages;
    rows.page=page;

    return rows;
  } catch(error) {
    console.log('dataif-service fetchData:'+error);
  } finally {
    if (conn) conn.end();
  }
};

exports.fetchDataSensor = async function(req, res) {
  var conn;
  try{
    conn = await db.getConnection();

    var usertype=req.user.user_type;

    var start = 0;
    var page=0;
    var pageSize=10;
    var reqpage=req.query.page;
    var reqpageSize=req.query.pageSize;
    var reqsrchword=req.query.srchword;
    if(reqpage!=undefined) page=reqpage;
    if(reqpageSize!=undefined) pageSize=reqpageSize;
    if (page <= 0) page = 1;
    else start = (page - 1) * pageSize;
    console.log('dataif-service fetchDataSensor:'+req.user.userid);
    var query;
    if(usertype=="9") query = 'SELECT count(*) cnt FROM webdb.tb_dataif a inner join webdb.tb_sensor b on a.sensor_board_idx=b.board_idx left outer join webdb.tb_file c on c.board_type="tb_dataif" and c.board_idx=a.board_idx';
    else query = 'SELECT count(*) cnt FROM webdb.tb_dataif a inner join webdb.tb_sensor b on a.sensor_board_idx=b.board_idx left outer join webdb.tb_file c on c.board_type="tb_dataif" and c.board_idx=a.board_idx where b.ins_id="'+req.user.userid+'"'; 
    var rows = await conn.query(query);
    var totalPages=Math.ceil(rows[0].cnt / pageSize);
    if (page > totalPages) {
      var rtn=[];
      rtn.totalPages=totalPages;
      rtn.page=page;
      return rtn;
    }

    var query;
    if(usertype=="9") query = `SELECT a.*, sen_mng_no, file_type, file_no, b.ins_id sen_ins_id,`
      +` case when permit_type="N" then "사용자요청" when permit_type="U" then "소유자허가" when permit_type="Y" then "연계준비중" when permit_type="S" then "연계중" when permit_type="E" then "연계완료" end permit_type_nm`
      +` FROM webdb.tb_dataif a inner join webdb.tb_sensor b on a.sensor_board_idx=b.board_idx left outer join webdb.tb_file c on c.board_type="tb_dataif" and c.board_idx=a.board_idx order by a.board_idx desc LIMIT ${start}, ${pageSize}`;
    else query = `SELECT a.*, sen_mng_no, file_type, file_no, b.ins_id sen_ins_id, case when permit_type="N" then "사용자요청" when permit_type="U" then "소유자허가" when permit_type="Y" then "연계준비중" when permit_type="S" then "연계중" when permit_type="E" then "연계완료" end permit_type_nm FROM webdb.tb_dataif a inner join webdb.tb_sensor b on a.sensor_board_idx=b.board_idx left outer join webdb.tb_file c on c.board_type="tb_dataif" and c.board_idx=a.board_idx where b.ins_id="${req.user.userid}" order by a.board_idx desc LIMIT ${start}, ${pageSize}`; 
    rows = await conn.query(query); // 쿼리 실행

    rows.totalPages=totalPages;
    rows.page=page;

    return rows;
  } catch(error) {
    console.log('dataif-service fetchDataSensor:'+error);
  } finally {
    if (conn) conn.end();
  }
};

exports.retrieveData = async function(req, res) {
  var conn;
  try{
    conn = await db.getConnection();

    var query = 'SELECT a.*, b.sen_mng_no, c.sen_name, c.sen_grp, c.prj_grp, d.name FROM webdb.tb_dataif a inner join webdb.tb_sensor b on a.sensor_board_idx=b.board_idx inner join webdb.tb_device c on b.dev_board_idx=c.board_idx inner join webdb.tb_user d on a.ins_id=d.userid where a.board_idx='+req.params.id;
    var rows = await conn.query(query); // 쿼리 실행

    return rows[0];
  } catch(error) {
    console.log('dataif-service retrieveData:'+error);
  } finally {
    if (conn) conn.end();
  }
};

exports.create = async function(req, res) {
  var conn;
  try{
    conn = await db.getConnection();
    await conn.beginTransaction() // 트랜잭션 적용 시작

    var query;
    var rows;
    var queryStr;

    var senIdx=req.body.sensor_board_idx;
    var arrsensorboardidx=[];
    if(typeof senIdx=='object') arrsensorboardidx=senIdx;
    else arrsensorboardidx.push(senIdx);

    if(req.body.if_type=="DBS") req.body.fieldArr=['dbname', 'end_date', 'hostip', 'if_subtype', 'if_type', 'password', 'port', 'req_dtl', 'sensor_board_idx', 'strt_date', 'tbname', 'userid', 'ins_id'];
    else if(req.body.if_type=="COM")
      if(req.body.if_subtype=="MQT") req.body.fieldArr=['end_date', 'if_subtype', 'if_type', 'req_dtl', 'sensor_board_idx', 'strt_date', 'ins_id'];
      else if(req.body.if_subtype=="WEB") req.body.fieldArr=['end_date', 'if_subtype', 'if_type', 'req_dtl', 'sensor_board_idx', 'strt_date', 'ins_id'];

    for(idx in arrsensorboardidx){
      req.body.sensor_board_idx=arrsensorboardidx[idx];
      //query = 'select count(board_idx) cnt from webdb.tb_sensor where ins_id="'+req.user.userid+'" and board_idx='+arrsensorboardidx[idx];
      //rows = await conn.query(query);
      queryStr=utils.makeInsertFieldQuery(req);
      /*if(rows[0].cnt>0) {
        if(req.body.if_type=="DBS") query = 'insert into webdb.tb_dataif (dbname, end_date, hostip, if_subtype, if_type, password, port, req_dtl, sensor_board_idx, strt_date, tbname, userid, ins_id, permit_type) values ('+queryStr+', "Y")';
        else if(req.body.if_type=="COM")
          if(req.body.if_subtype=="MQT") query = 'insert into webdb.tb_dataif (end_date, hostip, if_subtype, if_type, port, req_dtl, sensor_board_idx, strt_date, tbname, ins_id, permit_type) values ('+queryStr+', "Y")';
          else if(req.body.if_subtype=="WEB") query = 'insert into webdb.tb_dataif (end_date, hostip, if_subtype, if_type, port, req_dtl, sensor_board_idx, strt_date, ins_id, permit_type) values ('+queryStr+', "Y")';
        rows = await conn.query(query);
      } else {*/
        if(req.body.if_type=="DBS") query = 'insert into webdb.tb_dataif (dbname, end_date, hostip, if_subtype, if_type, password, port, req_dtl, sensor_board_idx, strt_date, tbname, userid, ins_id) values ('+queryStr+')';
        else if(req.body.if_type=="COM")
          if(req.body.if_subtype=="MQT") query = 'insert into webdb.tb_dataif (end_date, if_subtype, if_type, req_dtl, sensor_board_idx, strt_date, ins_id) values ('+queryStr+')';
          else if(req.body.if_subtype=="WEB") query = 'insert into webdb.tb_dataif (end_date, if_subtype, if_type, req_dtl, sensor_board_idx, strt_date, ins_id) values ('+queryStr+')';
        rows = await conn.query(query);
      //}
    }
    await conn.commit() // 커밋

    query = 'select sen_mng_no, b.sen_name, a.ins_id from webdb.tb_sensor a inner join webdb.tb_device b on a.dev_board_idx=b.board_idx where a.board_idx='+req.body.sensor_board_idx;
    rows = await conn.query(query);
    req.body.from=req.user.userid;
    if(rows[0].ins_id=='1') req.body.to='jaipl@naver.com';
    else req.body.to=rows[0].ins_id;
    req.body.subject=rows[0].sen_name+"("+rows[0].sen_mng_no+")의 데이터연계 사용허가를 요청합니다.";
    req.body.text=req.body.req_dtl+'\r\n\r\n https://swiu_testbed.dongguk.edu 접속해서 "데이터연계 사용허가 관리" 메뉴에서 내용을 확인하시기 바랍니다.';
    utils.sendEmail(req);

    return rows;
  } catch(error) {
    if (conn) await conn.rollback(); // 롤백
    //return res.status(500).json(err)
    console.log('dataif-service create:'+error);
  } finally {
    if (conn) conn.release();
  }
};

exports.update = async function(req, res) {
  var conn;
  try{
    conn = await db.getConnection();
    if(req.body.if_type!="DBS") {
      req.body.hostip='';
      req.body.port='';
      req.body.userid='';
      req.body.password='';
      req.body.dbname='';
      req.body.tbname='';
    }
    req.body.fieldArr=['dbname', 'end_date', 'hostip', 'if_subtype', 'if_type', 'password', 'port', 'req_dtl', 'sensor_board_idx', 'strt_date', 'tbname', 'userid'];
    var queryStr=utils.makeBoardUpdateFieldQuery(req);
    var query = 'update webdb.tb_dataif set '+queryStr;
    var rows = await conn.query(query); // 쿼리 실행

    return rows;
  } catch(error) {
    console.log('dataif-service update:'+error);
  } finally {
    if (conn) conn.end();
  }
};

exports.delete = async function(req, res) {
  var rowsFle;
  var conn;
  try{
    conn = await db.getConnection();
    await conn.beginTransaction() // 트랜잭션 적용 시작

    var query = 'select file_path from webdb.tb_file where board_type="tb_dataif" and board_idx='+req.params.id;
    rowsFle = await conn.query(query); // 쿼리 실행

    query = 'delete from webdb.tb_file where board_type="tb_dataif" and board_idx='+req.params.id;
    var rows = await conn.query(query); // 쿼리 실행

    query = 'delete from webdb.tb_dataif where board_idx='+req.params.id;
    rows = await conn.query(query); // 쿼리 실행

    if(req.body.count>0){
      query = 'delete from webdb.tb_monsensor where sub_board_idx='+req.params.id;
      rows = await conn.query(query);
    }

    await conn.commit() // 커밋
    for(var idx=0;idx<rowsFle.length;idx++){
      var rowdata=rowsFle[idx];
      var filePath = __dirname + "/../" + rowdata.file_path; // 삭제할 파일의 위치​
      fs.unlink(filePath, function(err){});
    }

    return rows;
  } catch(error) {
    if (conn) await conn.rollback(); // 롤백
    //return res.status(500).json(err)
    console.log('dataif-service delete:'+error);
  } finally {
    if (conn) conn.release();
  }  
};

exports.retrieveDataProject = async function(req, res) {
  var conn;
  try{
    conn = await db.getConnection();
    var query = 'SELECT * FROM webdb.tb_dataif where prj_board_idx='+req.params.id;
    var rows = await conn.query(query); // 쿼리 실행
    var post=rows;
    /*
    for(var idx=0;idx<post.length;idx++){
      query = 'SELECT file_type, file_no, mime_type, org_file_name, file_size, file_path, board_type FROM webdb.tb_file where board_type="tb_dataif" and board_idx='+post[idx].board_idx;
      rows = await conn.query(query); // 쿼리 실행
      var file={};
      var flearr=['file_type', 'file_no', 'mime_type', 'org_file_name', 'file_size', 'file_path', 'board_type'];
      var fileNo=0;
      var file_type='';
      for(var idx=0;idx<rows.length;idx++){
        var rowdata=rows[idx];
        for(key in rowdata){
            if(key=='file_type') file_type=rowdata[key];
            if(flearr.indexOf(key)>-1 && file_type=='img') post[key]=rowdata[key];
            else file[key]=rowdata[key];
          }
        if(fileNo==0) post.file=[];
        if(file.file_type) post.file.push(file);
        fileNo++;
        file={};
      }
    }
*/
    return post;
  } catch(error) {
    console.log('dataif-service retrieveDataProject:'+error);
  } finally {
    if (conn) conn.end();
  }
};

exports.permit = async function(req, res) {
  var conn;
  try{
    conn = await db.getConnection();
    var query ;
    var permit_type=req.query.permit_type;
    var sen_ins_id=req.query.sen_ins_id;
    var sen_grp=req.query.sen_grp;
    if(req.user.user_type=="9")
      if(permit_type=="Y")
        if(sen_ins_id==req.user.userid) query = 'update webdb.tb_dataif set permit_type="N" ';
        else query = 'update webdb.tb_dataif set permit_type="U" ';
      else query = 'update webdb.tb_dataif set permit_type="Y" ';
    else
      if(permit_type=="U") query = 'update webdb.tb_dataif set permit_type="N" ';
      else query = 'update webdb.tb_dataif set permit_type="U" ';
      
    if(req.query.if_type=="COM"){
      if(sen_grp=="0001") query += ', hostip="210.94.199.140" ';
      else if(sen_grp=="0002" || sen_grp=="0003") query += ', hostip="210.94.199.225" ';
      if(req.query.if_subtype=="WEB") query += ', port="3233" ';
      else query += ', port="1883" ';
    }
    query += 'where board_idx='+req.query.board_idx;
    var rows = await conn.query(query); // 쿼리 실행

    return rows;
  } catch(error) {
    console.log('dataif-service permit:'+error);
  } finally {
    if (conn) conn.end();
  }
};

exports.getClass = async function(req, res) {
  var conn;
  try{
    conn = await db.getConnection();

    var senIdx=req.body.sensor_board_idx;
    var arrsensorboardidx=[];
    var whereStr;
    var queryStr='';
    if(typeof senIdx=='object') arrsensorboardidx=senIdx;
    else arrsensorboardidx.push(senIdx);

    for(idx in arrsensorboardidx)
      queryStr += '"'+arrsensorboardidx[idx] + '",';
    queryStr=queryStr.substr(0,queryStr.length-1);
    if(arrsensorboardidx.length==1) whereStr='b.board_idx="'+queryStr+'"';
    else whereStr='b.board_idx in ('+queryStr+')';

    var query = 'SELECT a.sen_grp, a.prj_grp, b.sen_id FROM webdb.tb_device a inner join webdb.tb_sensor b on a.board_idx=b.dev_board_idx where '+whereStr;
    var rows = await conn.query(query); // 쿼리 실행
    var post=rows;

    return post;
  } catch(error) {
    console.log('dataif-service getClass:'+error);
  } finally {
    if (conn) conn.end();
  }
};

exports.s_getCount = async function(req, res) {
  var conn;
  try{
    conn = await s_db.getConnection();
    
    var senId=req.body.s_senId;
    var arrsenId=[];
    var whereStr;
    var queryStr='';
    if(typeof senId=='object') arrsenId=senId;
    else arrsenId.push(senId);

    for(idx in arrsenId)
      queryStr += '"'+arrsenId[idx] + '",';
    queryStr=queryStr.substr(0,queryStr.length-1);
    if(arrsenId.length==1) whereStr='senid="'+queryStr+'"';
    else whereStr='senid in ('+queryStr+')';

    var query = 'SELECT count(senid) cnt, senid FROM appdb.sensor where '+whereStr+' and sendatetime between date("'+utils.to_date_format(req.body.strt_date,'-')+'") and date("'+utils.to_date_format(req.body.end_date,'-')+'") group by senid';
    var rows = await conn.query(query); // 쿼리 실행
    var post=rows;

    return post;
  } catch(error) {
    console.log('dataif-service s_getCount:'+error);
  } finally {
    if (conn) conn.end();
  }
};

exports.getCount = async function(req, res) {
  var conn;
  try{
    conn = await db.getConnection();

    var senId=req.body.senId;
    var arrsenId=[];
    var whereStr;
    var queryStr='';
    if(typeof senId=='object') arrsenId=senId;
    else arrsenId.push(senId);

    for(idx in arrsenId)
      queryStr += '"'+arrsenId[idx] + '",';
    queryStr=queryStr.substr(0,queryStr.length-1);
    if(arrsenId.length==1) whereStr='senid="'+queryStr+'"';
    else whereStr='senid in ('+queryStr+')';

    var query = 'SELECT count(senid) cnt, senid FROM appdb.sensor where '+whereStr+' and sendatetime between date("'+utils.to_date_format(req.body.strt_date,'-')+'") and date("'+utils.to_date_format(req.body.end_date,'-')+'") group by senid';
    var rows = await conn.query(query); // 쿼리 실행
    var post=rows;

    return post;
  } catch(error) {
    console.log('dataif-service getCount:'+error);
  } finally {
    if (conn) conn.end();
  }
};

exports.setCount = async function(req, res) {
  var conn;
  try{
    conn = await db.getConnection();
    var query = 'update webdb.tb_dataif set data_cnt='+req.body.count+' where board_idx='+req.body.modal_board_idx;
    var rows = await conn.query(query); // 쿼리 실행

    return rows;
  } catch(error) {
    console.log('dataif-service setCount:'+error);
  } finally {
    if (conn) conn.end();
  }
};