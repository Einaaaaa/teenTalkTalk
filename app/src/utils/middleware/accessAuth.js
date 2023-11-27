
// 접근권한 미들웨어
const accessLevels = {
  0: 0, // 일반사용자
  1: 1, // 최고관리자
  2: 2, // 부관리자
  3: 3, // 정책관리자
};

// 접근권한 미들웨어
module.exports = function accessAuth(requiredAccessLevel) {
return function(req, res, next) {
        // user.role을 통해 사용자의 접근권한을 확인
        const userRole = req.session.user.data.user_role;

        // accessLevels를 통해 사용자의 접근권한을 받아옴
        const userAccessLevel = accessLevels[userRole];
        // 접근 권한이 요구되는 접근 권한보다 낮은 경우, 403 Forbidden response를 반환
        if (userAccessLevel > requiredAccessLevel || userAccessLevel == 0) { // 접근권한이 요구되는 접근권한보다 낮은 경우 or 일반사용자인 경우
                if (requiredAccessLevel == 1) {
                        console.log('최고관리자만 접근 가능합니다.');
                } else if (requiredAccessLevel == 2) {
                        console.log('부관리자 이상 접근 가능합니다.');
                } else if (requiredAccessLevel == 3) {
                        console.log('정책관리자 이상 접근 가능합니다.');
                }

                return res.redirect(`/admin/error/403?requiredAccessLevel=${requiredAccessLevel}`);
        }

        // 만약 접근 권한이 요구되는 접근 권한보다 높거나 같은 경우, 다음으로 이동
        next();
};
}
