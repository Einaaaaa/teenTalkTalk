const path = require("path");
const express = require("express");
const router = express.Router();

const ensureAuth = require("../../utils/middleware/ensureAuth");
const asyncHandler = require("../../utils/middleware/asyncHandler");

router.get('/403', ensureAuth, asyncHandler(async function (req, res) {
    const requiredAccessLevel = req.query.requiredAccessLevel;
    console.error('403 error: 요구 권한 ' + requiredAccessLevel);
    res.render('error/403', { requiredAccessLevel });
}, 'error-router / error:' + __dirname));

module.exports = router;
