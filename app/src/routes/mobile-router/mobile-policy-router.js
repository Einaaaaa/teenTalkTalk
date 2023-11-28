const path = require("path");
var express = require("express");
var router = express.Router();
var mobile_policy_controller = require("../../controllers/mobile-controller/mobile-policy-controller");
var verifyToken = require("../../middleware/verify_token");



router.get('/get-all-policy/:sortOrderCode', async function(req, res){
    try{
      // console.log(req.params.sortOrderCode);
      var result = await mobile_policy_controller.getAllPolicy(req,res);
      // console.log('mobile-router get-all-policy result : ', result);
      // res.render('policy/get-all-policy', {
      //     posts:result,
      //     user:req.user
      // }
      // );
      res.json({
        resp:true,
        message : 'get all policies',
        policies : result,
      })
  } catch(error) {
      console.log('policy-router get-all-policy error:'+error);
      res.json({
        resp:false,
        message : 'Failure get all policies'
      })
  }
  });

  router.get('/get-policy-by-id/:policyId', async function(req, res){
    try{
      console.log(req.params.policyId);
      var result = await mobile_policy_controller.getPolicyById(req,res);
      res.json({
        resp:true,
        message : 'get policy by id',
        policies : result,
      })
  } catch(error) {
      console.log('policy-router get-policy-by-id error:'+error);
      res.json({
        resp:false,
        message : 'Failure get-policy-by-id'
      })
  }
  });
  
  
  
  
  
  // 정책 텍스트-제목 검색
  router.get('/get-search-policy/:searchValue', async function(req, res) {
    // console.log('get-search-policy');
    // console.log('mobile-router', req.query.searchValue );
    // console.log('mobile-router', req.query.sortOrderCode );
    try{
      var result = await mobile_policy_controller.getSearchPolicy(req,res);
      // console.log('mobile-router get-search-policy result : ', result);
  
      res.json({
        resp:true,
        message : 'get search policies',
        policies : result
      })
  } catch(error) {
      console.log('policy-router get-search-policy error:'+error);
      res.json({
        resp:false,
        message : 'Failure get search policies'
      })
  }
  })
  
  // 검색 조건 선택 결과

  router.get('/get-select-policy?:values', async function(req, res) {
    console.log(req.query);


    try {
      var result = await mobile_policy_controller.getPolicyBySelect(req, res);
  
      res.json({
        resp: true,
        message: 'get policies by select',
        policies: result,
      })
    } catch(error) {
      console.log('policy-router get-select-policy error:' + error);
      res.json({
        resp: false,
        message: 'Failure get policies by select'
      })
    }
  })
  
  function createUri(values) {
    const paths = [
      'institutionCodeName',
      'institutionCodeDetail',
      'targetCodeName',
      'targetCodeDetail',
      'fieldCodeName',
      'fieldCodeDetail',
      'characterCodeName',
      'characterCodeDetail'
    ];
  
    let uri = '/get-select-policy/';
  
    // 선택된 값에 따라 경로 생성
    if (values.length === 1) {
      uri += values[0];
    } else if (values.length === 2) {
      uri += `${paths[values[0]]}/${values[1]}`;
    } else if (values.length === 3) {
      uri += `${paths[values[0]]}/${values[1]}/${paths[values[2]]}/${values[3]}`;
    } else if (values.length === 4) {
      uri += `${paths[values[0]]}/${values[1]}/${paths[values[2]]}/${values[3]}/${paths[values[4]]}/${values[5]}`;
    }
  
    return uri;
  }
  
  

  // 필요없음
router.get('/get-all-policy-for-search', async function(req, res) {
    try{
      var result = await mobile_policy_controller.getAllPolicyForSearch(req,res);
      // console.log('mobile-router get-all-posts-for-search result : ', result);
  
      res.json({
        resp:true,
        message : 'get-all-posts-for-search policies',
        policies : result
      })
  } catch(error) {
      console.log('policy-router get-search-policy error:'+error);
      res.json({
        resp:false,
        message : 'Failure get-search-policy policies'
      })
  }
  });

  router.post('/scrap-or-unscrap-policy', verifyToken, async function(req, res){
    try {

      var result = await mobile_policy_controller.scrapOrUnscrapPolicy(req, res);
      // console.log('mobile-router scrap-or-unscrap-policy result : ', result);

      if (result == 0) {
        res.json({
          resp:true,
          message : 'scrap'
        })
      } else if (result == 1) {
        res.json({
          resp : true,
          message : 'unscrap'
        })
      }

    } catch(error) {
      console.log('policy-router scrap-or-unscrap-polic error:'+error);
      res.json({
        resp:false,
        message : 'Failure scrap-or-unscrap-polic'
      })
    }
  } )

  router.get('/get-scrapped-policy', verifyToken, async function(req, res){
    try{
      var result = await mobile_policy_controller.getScrappedPolicy(req,res);
      // console.log('mobile-router get-policy-by-user result : ', result);

      res.json({
        resp:true,
        message : 'get-scrapped-policy',
        policies : result,
      })
  } catch(error) {
      console.log('policy-router get-scrapped-policy error:'+error);
      res.json({
        resp:false,
        message : 'Failure get-scrapped-policy'
      })
  }})

  router.get('/check-policy-scrapped/:uidPolicy', verifyToken, async function(req, res){
    // console.log('check-policy-scrapped');
    try{
      // console.log(req.params.uidPolicy)
      const result = await mobile_policy_controller.checkPolicyScrapped(req,res);
      // console.log('mobile-router check-policy-scrapped result : ', result);

      res.json({
        resp:true,
        message : 'check-policy-scrapped',
        isScrapped : result
      })
  } catch(error) {
      console.log('policy-router check-policy-scrapped error:'+error);
      res.json({
        resp:false,
        message : 'Failure check-policy-scrapped',
        isScrapped : 0
  
      })
  }
})

  



  

 

  

  

  module.exports = router;