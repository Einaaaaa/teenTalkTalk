var mobile_event_service = require("../../services/mobile-services/mobile-event-service");

// 무화과 지급 - 출석 체크
exports.giveFigForAttendance = async function(req, res) {
  try{
    var result = await mobile_event_service.giveFigForAttendance(req);
    return result;
  } catch(error) {
    console.log('mobile-event-controller giveFigForAttendance:'+error);
  }
};

// 무화과 지급 - 친구 초대
exports.giveFigForInvitation = async function(req, res) {
  try{
    var result = await mobile_event_service.giveFigForInvitation(req);
    return result;
  } catch(error) {
    console.log('mobile-event-controller giveFigForInvitation:'+error);
  }
};

// 무화과 지급 - 주간 무화과 챌린지
exports.giveFigForWeeklyFigChallenge = async function(req, res) {
  try{
    var result = await mobile_event_service.giveFigForWeeklyFigChallenge(req);
    return result;
  } catch(error) {
    console.log('mobile-event-controller giveFigForWeeklyFigChallenge:'+error);
  }
};

// 가입 24시간 이내 여부 확인
exports.checkUserWithin24Hours = async function(req, res) {
  try{
    var result = await mobile_event_service.checkUserWithin24Hours(req);
    return result;
  } catch(error) {
    console.log('mobile-event-controller checkUserWithin24Hours:'+error);
  }
};

// 이벤트 참여 내역 확인
exports.checkEventParticipation = async function(req, res) {
  try{
    var result = await mobile_event_service.checkEventParticipation(req);
    return result;
  } catch(error) {
    console.log('mobile-event-controller checkEventParticipation:'+error);
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


  // 이벤트 참여
  exports.participateEvent = async function(req, res) {
    try{
      var result = await mobile_event_service.participateEvent(req);
      return result;
    } catch(error) {
      console.log('mobile-event-controller participateEvent:'+error);
    }
  }

