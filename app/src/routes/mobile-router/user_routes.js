
const express = require("express");
const router = express.Router();
const user = require('../../controllers/mobile-controller/user_controller');
const verifyToken = require('../../middleware/verify_token');

// import { uploadsCover, uploadsProfile } from '../lib/multer';

router.post('/user', user.createUser);
// router.get('/user/get-User-By-Id', verifyToken, user.getUserById);
router.get('/user/verify-email/:code/:email', user.verifyEmail);
// Middleware [ Token, image ]  - Profile Image required
// router.put('/user/update-cover', [verifyToken, uploadsCover.single('cover')], user.updatePictureCover);
// router.put('/user/update-image-profile', [verifyToken, uploadsProfile.single('profile')], user.updatePictureProfile);
// router.put('/user/update-data-profile', verifyToken, user.updateProfile);
router.put('/user/change-password', verifyToken, user.changePassword);
// router.put('/user/change-account-privacy', verifyToken, user.changeAccountPrivacy);
// router.get('/user/get-search-user/:username', verifyToken, user.getSearchUser);
// router.get('/user/get-another-user-by-id/:idUser', verifyToken, user.getAnotherUserById);
// router.post('/user/add-new-friend', verifyToken, user.AddNewFollowing);
// router.post('/user/accept-follower-request', verifyToken, user.AcceptFollowerRequest);
// router.delete('/user/delete-following/:idUser', verifyToken, user.deleteFollowing);
// router.get('/user/get-all-following', verifyToken, user.getAllFollowings);
// router.get('/user/get-all-followers', verifyToken, user.getAllFollowers);
// router.delete('/user/delete-followers/:idUser', verifyToken, user.deleteFollowers);
// export default router;
router.get('/hello', async function(req, res){
    try{
    res.send('hello route-User');
    console.log('1');
    } catch(err){
        console.log(err);
    }
})
module.exports = router;