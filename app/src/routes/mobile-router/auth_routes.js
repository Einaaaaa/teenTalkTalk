const express = require("express");
const router = express.Router();
const auth = require('../../controllers/mobile-controller/auth_controller');
const verifyToken = require('../../middleware/verify_token');



router.post('/auth-login', auth.login);
router.get('/auth/renew-login', verifyToken, auth.renweLogin);

router.get('/hello', async function(req, res){
    try{
    res.send('hello route-Auth');
    console.log('route-auth');
    } catch(err){
        console.log(err);
    }
})

module.exports = router;
// export default router;