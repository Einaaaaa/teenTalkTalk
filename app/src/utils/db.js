const mysql = require('mariadb');
var config = require('./db-config'); // ./는 현재 디렉토리를 나타냅니다 
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PSWORD,
  database: process.env.DB_DATABASE,
  connectionLimit: 10
});

// pool.query('SELECT * FROM tb_user', function(err, results, fields) {
//   if (err) {
//     console.log(err);
//   }
//   console.log(results);
// });



// pool.getConnection(function(err, connection){  
//   if( err ){
//       if( err.code === 'PROTOCOL_CONNECTION_LOST' ) console.log('DATABASE CONNECTION WAS CLOSED');
//       if( err.code === 'ER_CON_COUNT_ERROR' ) console.log('DATABASE HAS TO MANY CONNECTIONS');
//       if( err.code === 'ECONNREFUSED' ) console.log('DATABASE CONNECTION WAS REFUSED');
//   } else {
//     console.log('DataBase is connected to '+process.env.DB_DATABASE);
//   }
  
//   if( connection ) connection.release();

  
//   return;
// });

module.exports = pool;