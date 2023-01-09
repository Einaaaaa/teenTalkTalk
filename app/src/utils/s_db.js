const mysql = require('mariadb');
var config = require('./s_db-config'); // ./는 현재 디렉토리를 나타냅니다 
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PSWORD,
  database: process.env.DB_DATABASE,
  port: process.env.DB_PORT,
  connectionLimit: 5,
  charset: process.env.DB_CHARSET
});

module.exports = pool;