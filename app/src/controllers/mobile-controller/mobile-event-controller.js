var mobile_event_service = require("../../services/mobile-services/mobile-event-service");

// 무화과 지급하기
exports.giveFig = async function(req, res) {
  try{
    var result = await mobile_event_service.giveFig(req);
    return result;
  } catch(error) {
    console.log('mobile-event-controller giveFig:'+error);
  }
};

// 출석 체크 기록 불러오기
exports.getAttendance = async function(req, res) {
  try{
    var result = await mobile_event_service.getAttendance(req);
    return result;
  } catch(error) {
    console.log('mobile-event-controller getAttendance:'+error);
  }
};

// 무화과 사용 내역 불러오기
  exports.fetchFigUsageByUser = async function(req, res) {
      try{
        var result = await mobile_event_service.fetchFigUsageByUser(req);
        return result;
      } catch(error) {
        console.log('mobile-event-controller fetchFigUsageByUser:'+error);
      }
    };

  // 무화과 지급 내역(이벤트 참여 내역) 불러오기
  exports.fetchFigRewardByUser = async function(req, res) {
    try{
      var result = await mobile_event_service.fetchFigRewardByUser(req);
      return result;
    } catch(error) {
      console.log('mobile-event-controller fetchFigRewardByUser:'+error);
    }
  };