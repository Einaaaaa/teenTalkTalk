var db = require('../../utils/db');
var policy_service = require("../../services/policy-service");
var code_service = require("../../services/codeData-service");



exports.getAllPolicy = async function(req, res) {
    try{
        var result = await policy_service.getAllPolicy(req,res);
        // console.log(result);
        return result;
      } catch(error) {
        console.log('policy-controller getAllPolicy:'+error);
      }
    };


exports.getSearchPolicy = async function(req, res) {
  try{
    var result = await policy_service.getSearchPolicy(req, res);
    // console.log('mobile-policy-controller getSearchPolicy:');
    return result;
  } catch (error){
    console.log('policy-controller getSearchPolicy:'+error);
  }
}

exports.getAllPolicyForSearch = async function(req, res) {
  try{
      var result = await policy_service.getAllPolicyForSearch(req,res);
      // console.log(result);
      return result;
    } catch(error) {
      console.log('policy-controller getAllPolicyForSearch:'+error);
    }
  };

exports.getBannerData = async function(req, res) {
  try{
    var result = await policy_service.getBannerData(req);
    return result;
  } catch(error) {
    console.log('mobile-policy-controller fetchBannerData:'+error);
  }
};