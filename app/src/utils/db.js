const mysql = require('mariadb');
var config = require('./db-config'); // ./는 현재 디렉토리를 나타냅니다 
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PSWORD,
  database: process.env.DB_DATABASE,
  connectionLimit: 10
});
/*
//연결 되는 지 확인
pool.query('SELECT * FROM tb_user', function(err, results, fields) {
  if (err) {
    console.log(err);
  }
  console.log(results);
});
*/
module.exports = pool;