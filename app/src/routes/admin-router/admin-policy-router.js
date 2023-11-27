const path = require("path");
var express = require("express");
var fs = require("fs");
var XLSX = require('xlsx');
var json2csv = require('json2csv').parse;
var router = express.Router();
var policy_controller = require("../../controllers/common-controller/policy-controller");
var code_controller = require("../../controllers/common-controller/codeData-controller");

var codeName = require('../../public/js/home/getCodeName');
const { json } = require("body-parser");

const ensureAuth = require("../../utils/middleware/ensureAuth");
const accessAuth = require("../../utils/middleware/accessAuth");
const asyncHandler = require("../../utils/middleware/asyncHandler");
const e = require("connect-flash");

router.get('/show', ensureAuth, accessAuth(3), asyncHandler(async function (req, res) {
    var crtpage = 1;
    console.log(req.url);
    var totalPage = 1;
    var pageSize = 8; //한 페이지에 보여줄 정책 수
    if (req.url.split('/').length == 2){ // 처음 페이지 로딩
        var result = await policy_controller.fetchData(req, res);
        totalPage = Math.ceil(result.length/pageSize);
        result = result.slice(0, pageSize); //처음 페이지에 보여줄 정책 수만큼 가져옴
    } else { //페이지 이동
        crtpage = req.url.split('=')[1]; //현재 페이지
        var result = await policy_controller.fetchData(req, res);
        if(crtpage == undefined) crtpage = 1; //현재 페이지가 없으면 1페이지로 설정
        if(crtpage < 1) crtpage = 1; //현재 페이지가 1보다 작으면 1페이지로 설정
        if(crtpage > Math.ceil(result.length/pageSize)) crtpage = Math.ceil(result.length/pageSize); //현재 페이지가 마지막 페이지보다 크면 마지막 페이지로 설정
        var start = (crtpage-1)*pageSize;
        var end = crtpage*pageSize;
        totalPage = Math.ceil(result.length/pageSize);
        result = result.slice(start, end); //현재 페이지에 보여줄 정책 수만큼 가져옴
    }
    var code_data = await code_controller.getPolicyName();
    crtpage = parseInt(crtpage);
    res.render('policy/show', {
        posts:result,
        user:req.user,
        page:crtpage, //현재 페이지
        totalPage: totalPage, //총 페이지 수
        code_data:code_data,
        codeName:codeName.policy_code_to_name //정책 대상만 설정 해 놨음    
    });
}, 'policy-router show/ error:'));

// 정책 업로드 페이지
router.get('/upload', ensureAuth, accessAuth(3), asyncHandler(async function (req, res) {
    var code_data = await code_controller.getCodeData(req, res); //코드 데이터 가져오기
    res.render('policy/upload', { //정책 업로드 페이지 렌더링, 코드 데이터 전달
        code_data:code_data
        });
}, 'policy-router upload/ error:'));
router.post('/upload', asyncHandler(async function (req, res) {
    var result = await policy_controller.upload(req,res); // 정책 업로드
    if(result == 0) { //성공 시 정책 페이지로 이동
        res.redirect('/admin/policy/show');
    } else { //실패 시 정책 업로드 페이지로 이동
        res.redirect('/admin/policy/upload');
    }
}, 'policy-router upload/ error:'));

// 정책 수정 페이지
router.get('/update/:id', ensureAuth,accessAuth(3), asyncHandler(async function (req, res) {
    var result = await policy_controller.fetchpolicyByidx(req, res); //정책 데이터 가져오기
    // 접수 기간
    var start_month = result[0].application_start_date.getMonth()+1;
    if(start_month < 10) start_month = '0'+start_month;
    var start_date = result[0].application_start_date.getDate();
    if(start_date < 10) start_date = '0'+start_date;
    var start_day = result[0].application_start_date.getFullYear()+'-'+start_month+'-'+start_date;
    var end_month = result[0].application_end_date.getMonth()+1;
    if(end_month < 10) end_month = '0'+end_month;
    var end_date = result[0].application_end_date.getDate();
    if(end_date < 10) end_date = '0'+end_date;
    var end_day = result[0].application_end_date.getFullYear()+'-'+end_month+'-'+end_date;
    var code_data = await code_controller.getCodeData(req, res); //코드 데이터 가져오기
    var content = result[0].content
    res.render('policy/policy-update', { //정책 수정 페이지 렌더링, 정책 데이터, 코드 데이터 전달    
        post:result[0],
        code_data:code_data,
        start_date:start_day,
        end_date:end_day,
        content:content
        });
}, 'policy-router update/ error:'));

router.post('/update/:id', asyncHandler(async function (req, res) {
    var result = await policy_controller.updatePolicy(req, res); // 정책 수정
    if(result == 0) { //성공 시 정책 페이지로 이동
        res.redirect('/admin/policy/show');
    } else { //실패 시 에러 메시지 출력 후 정책 수정 페이지로 이동
        res.render('error', {
            error : '정책 수정에 실패했습니다. 다시 시도해주세요.',
            redirectPath : '/admin/policy/update/'+req.params.id
        });
    }
}, 'policy-router update/ error:'));


// 정책 삭제
router.get('/delete/:id', ensureAuth, accessAuth(3),asyncHandler(async function (req, res) {
    var policy_img = await policy_controller.fetchpolicyImgByidx(req, res); //정책 이미지 가져오기
    var result = await policy_controller.deletePolicy(req, res); //정책 삭제

    var imagePath = './src/public/upload/policy/' + policy_img[0].img;
    fs.access(imagePath, fs.constants.F_OK, function (err) {
        if (!err) {
            fs.unlink(imagePath, function (err) { //정책 이미지 삭제
                if (err) throw err;
                console.log('file deleted');
            });
        } else {
            console.log('no file');
        }
    });
    console.log(result);
    if(result == 0) { //성공 시 메시지 출력 후 정책 페이지로 이동
        res.redirect('/admin/policy/show');
    } else { //실패 시 에러 메시지 출력 후 정책 페이지로 이동
        res.render('error', {
            error : '정책 삭제에 실패했습니다. 다시 시도해주세요.',
            redirectPath : '/admin/policy/show'
        });
    }
}, 'policy-router delete/ error:'));


// 베너 관리
router.get('/banner', ensureAuth, accessAuth(2), asyncHandler(async function (req, res) {
    var result = await policy_controller.fetchBannerData(req,res);
    res.render('policy/banner', {banner:result});
}, 'policy-router banner/ error:'));
router.get('/banner/delete/:id', ensureAuth,accessAuth(2), asyncHandler(async function (req, res) {
    var banner_img = await policy_controller.fetchBannerImg(req, res);
    var result = await policy_controller.deleteBanner(req, res);
    var imagePath = './src/public/upload/banner/' + banner_img[0].banner_img;
    fs.access(imagePath, fs.constants.F_OK, function (err) {
        if (!err) {
            fs.unlink(imagePath, function (err) { //정책 이미지 삭제
                if (err) throw err;
                console.log('file deleted');
            });
        } else {
            console.log('no file');
        }
    });
    res.redirect('/admin/policy/banner');
}, 'policy-router banner delete/ error:'));

router.get('/banner/upload', ensureAuth, accessAuth(2), asyncHandler(async function (req, res) {
    res.render('policy/banner-upload');
}, 'policy-router banner upload/ error:'));
router.post('/banner/upload', asyncHandler(async function (req, res) {
    var result = await policy_controller.banner(req,res);
    if(result == 0) { //성공
        res.redirect('/admin/policy/banner');
    } else { //실패
        res.redirect('/admin/policy/banner/upload');
    }
}, 'policy-router banner/ error:'));

router.get('/regTest', function(req, res) {
    console.log('regTest');
    var result = policy_controller.regTest(req, res);
    res.redirect('/admin/policy/show');
});

//정책 정보 엑셀 다운로드
router.get('/csv', ensureAuth, asyncHandler(async function (req, res) {
  try {
    // 정책 데이터 가져오기
    var result = await policy_controller.fetchpolicy(req, res);
    var fields = ['board_idx', 'policy_name', 'policy_target_code', 'policy_institution_code', 'policy_field_code', 'policy_character_code', 'min_fund', 'max_fund', 'application_start_date', 'application_end_date', 'content'];
    var csv = json2csv(result, { fields: fields });

    // fs.writeFile('data.csv', csv, function(err) {
    //   if (err) throw err;
    //   console.log('File saved');
    // });
    
    // res.download('data.csv');

    fs.writeFile('data.csv', csv, function(err) {
        if (err) {
          console.error('File saving error:', err);
          res.status(500).send('Internal Server Error');
        } else {
          console.log('File saved');
          res.download('data.csv');
        }
      });
  } catch (error) {
    console.error('policy-router excel/ error:', error);
    res.status(500).send('Internal Server Error');
  }
}));

router.get('/gptPage', asyncHandler(async function (req, res) {
    res.render('policy/gpt');
}, 'policy-router gptPage/ error:'));

module.exports = router;