const App = require('./app');
const config = require('dotenv');

const main = async() => {

    config.config();
    console.log('hello');

    const app = new App();
    console.log('app');
    // await app.listen(process.env.PORT || '3000');
}

main();