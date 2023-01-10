
const createPool = require('mariadb');
const dbConfig = require('./kth.db.config');
const mysql = require('mariadb');


const pool = mysql.createPool({
  host: dbConfig.HOST,
  user: dbConfig.USER,
  password: dbConfig.PASSWORD,
  port:dbConfig.PORT,
  database: dbConfig.DATABASE,
});

// const connect = async () => {
//     const connection = await createPool({
//         host: 'localhost',
//         user: 'root',
//         password: '1004',
//         database: 'webdb',
//         connectionLimit: 10
//     });
//     return connection;
// };

pool.getConnection(function(err, connection){  
    if( err ){
        if( err.code === 'PROTOCOL_CONNECTION_LOST' ) console.log('DATABASE CONNECTION WAS CLOSED');
        if( err.code === 'ER_CON_COUNT_ERROR' ) console.log('DATABASE HAS TO MANY CONNECTIONS');
        if( err.code === 'ECONNREFUSED' ) console.log('DATABASE CONNECTION WAS REFUSED');
    } else {
      console.log('DataBase is connected to '+ dbConfig.DATABASE);
    }
    if( connection ) connection.release();
  
    
    return;
  });
  



module.exports = pool;