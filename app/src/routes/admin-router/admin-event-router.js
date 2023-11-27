const path = require("path");
var express = require("express");
var fs = require("fs");
var router = express.Router();
var event_controller = require("../../controllers/common-controller/event-controller");
var code_controller = require("../../controllers/common-controller/codeData-controller");
var dataif_controller = require("../../controllers/common-controller/dataif-controller");

const ensureAuth = require("../../utils/middleware/ensureAuth");
const asyncHandler = require("../../utils/middleware/asyncHandler");
const accessAuth = require("../../utils/middleware/accessAuth");


var codeName = require('../../public/js/home/getCodeName');

//이벤트 참여자 목록
router.get('/', ensureAuth, accessAuth(2), asyncHandler(async function (req, res) {
    var urltype = req.url.split('/')[1].split('=')[0];
    var crtpage = 1;
    var totalPage = 1;
    var pageSize = 6; //한 페이지에 보여줄 회원 정보 수
    if (urltype == '?page') { //페이지 이동
        crtpage = req.url.split('=')[1]; //현재 페이지
        // 순서 수정
        var result = await event_controller.fetchEventPart(req, res);
        if (crtpage == undefined) crtpage = 1; //현재 페이지가 없으면 1페이지로 설정
        if (crtpage < 1) crtpage = 1; //현재 페이지가 1보다 작으면 1페이지로 설정
        if (crtpage > Math.ceil(result.length / pageSize)) crtpage = Math.ceil(result.length / pageSize); //현재 페이지가 마지막 페이지보다 크면 마지막 페이지로 설정
        var start = (crtpage - 1) * pageSize;
        var end = crtpage * pageSize;
        totalPage = Math.ceil(result.length / pageSize);
        result = result.slice(start, end); //현재 페이지에 해당하는 회원 정보만 가져옴
    } else { //일반 접속
        var result = await event_controller.fetchEventPart(req, res);
        totalPage = Math.ceil(result.length / pageSize);
        result = result.slice(0, pageSize);
    }
    var code_data = await code_controller.getUserCodeName();
    // console.log(req.session);
    crtpage = parseInt(crtpage); //현재 페이지
    res.render('event/eventPart',
        {
        posts: result,
        code_data: code_data,
        page: crtpage, //현재 페이지
        totalPage: totalPage, //총 페이지 수
        codeName: codeName.user_code_to_name,
        emd_code_to_name: codeName.emd_code_to_name,
        user_type_to_name: codeName.user_type_to_name,
        });
    }, 'event-router / error:')
    );

    module.exports = router;