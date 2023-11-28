import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:teentalktalk/domain/blocs/blocs.dart';
import 'package:teentalktalk/domain/services/event_services.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_access_denied.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_checkLogin.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_getFig.dart';
import 'package:teentalktalk/ui/screens/event/attendance_event_page.dart';
import 'package:teentalktalk/ui/screens/event/event_list_page.dart';
import 'package:teentalktalk/ui/screens/event/new_weeklyFig_event_page.dart';
import 'package:teentalktalk/ui/screens/event/weeklyFig_event_page.dart';
import 'package:teentalktalk/ui/screens/policy/policy_list_page.dart';
import 'package:teentalktalk/ui/screens/register/user_type_page.dart';
import 'package:teentalktalk/ui/themes/theme_colors.dart';
import 'package:teentalktalk/ui/widgets/widgets.dart';

class SecondWeekMissionPage extends StatelessWidget {
  const SecondWeekMissionPage({Key? key, required this.hasParticipated})
      : super(key: key);
  final bool hasParticipated;

  @override
  Widget build(BuildContext context) {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    final bool isLogIn = authState is SuccessAuthentication;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: ThemeColors.third,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ThemeColors.third,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ThemeColors.primary,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5.h),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/Fig2.png',
                            height: 60.h,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            margin: EdgeInsets.all(10.w),
                            padding: EdgeInsets.all(10.w),
                            width: 300.w,
                            // height: 50.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: ThemeColors.primary, width: 2.w),
                              color: Colors.white,
                            ),
                            child: Column(children: [
                              Container(
                                margin: EdgeInsets.all(5.w),
                                padding: EdgeInsets.all(5.w),
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(245, 117, 33, 0.8),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: TextCustom(
                                  text: '이번주 미션',
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                ),
                              ),
                              StrokeText(
                                text: "정책 스크랩",
                                textStyle: TextStyle(
                                    fontSize: 30.sp,
                                    fontFamily: 'CookieRun',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                    color: ThemeColors.primary),
                                strokeColor: Colors.transparent,
                                strokeWidth: 2,
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  TextCustom(
                                    text: '관심있는 ',
                                  ),
                                  TextCustom(
                                    text: '정책 스크랩',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  TextCustom(
                                    text: '하면',
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  TextCustom(
                                    text: '무화과 ',
                                  ),
                                  TextCustom(
                                    text: '2개',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  TextCustom(
                                    text: '지급!',
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              // TextCustom(
                              //   text: '기간 : 2023.07.12 ~ 2023.07.18',
                              //   fontSize: 13.sp,
                              // ),
                            ]),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(25.w, 20.h, 10.w, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.sp),
                                    topRight: Radius.circular(30.sp)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1.r,
                                    blurRadius: 2.r,
                                    offset: const Offset(2, 0),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextCustom(
                                    text: '어떻게 참여하나요?',
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.person_outline_rounded,
                                        color: ThemeColors.primary,
                                        size: 70.sp,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const TextCustom(text: '1. 하단 버튼 클릭'),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          const TextCustom(
                                              text: '2. 복지검색 페이지 이동'),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          const TextCustom(
                                              text: '3. 관심있는 정책 스크랩하기'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: ThemeColors.primary,
                                    height: 30.h,
                                    thickness: 1,
                                  ),
                                  TextCustom(
                                    text: '꼭! 읽어보세요',
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),

                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  TextCustom(
                                    text: '- 본 이벤트는 로그인/회원가입 이후 참여 가능합니다.',
                                    fontSize: 12.sp,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  TextCustom(
                                    text: '- 정책 스크랩 시 무화과가 자동 지급됩니다.',
                                    fontSize: 12.sp,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  TextCustom(
                                    text: '- 한 계정당 최초 1회만 받을 수 있습니다.',
                                    fontSize: 12.sp,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  TextCustom(
                                    text: '- 중복 참여가 불가한 이벤트입니다.',
                                    fontSize: 12.sp,
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        if (isLogIn && hasParticipated) {
                                          modalAccessDenied(
                                              context, "이미 참여한 이벤트입니다.",
                                              onPressed: () {});
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PolicyListPage(
                                                          selectedCodes:
                                                              SelectedCodes(
                                                        policyInstitution: [],
                                                        policyTarget: [],
                                                        policyField: [],
                                                        policyCharacter: [],
                                                        // policyArea: []
                                                      ))));
                                          // eventService
                                          //     .giveFigForWeeklyFigChallenge(
                                          //         '4'); //eid
                                          // Navigator.pushAndRemoveUntil(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           const newWeeklyFigEventPage(),
                                          //     ),
                                          //     (_) => false);
                                          // modalGetFig(context, '4'); //eid
                                        }
                                      },
                                      child: Center(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 310.w,
                                          height: 50.h,
                                          padding: EdgeInsets.fromLTRB(
                                              20.w, 10.h, 20.w, 10.h),
                                          decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  245,
                                                  117,
                                                  33,
                                                  0.8), //ThemeColors.fig_pink,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(30.r),
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(4, 4),
                                                  blurRadius: 15,
                                                  spreadRadius: 1,
                                                ),
                                                BoxShadow(
                                                  color: Colors.white,
                                                  offset: Offset(-4, -4),
                                                  blurRadius: 15,
                                                  spreadRadius: 1,
                                                ),
                                              ]),
                                          child: TextCustom(
                                            text: hasParticipated
                                                ? "참여완료"
                                                : "정책 스크랩하러 가기",
                                            fontSize: 20.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )),
                                  // NeumorphicButton(
                                  //     margin: EdgeInsets.only(
                                  //         left: 20.w, right: 20.w),
                                  //     style: NeumorphicStyle(
                                  //         shape: NeumorphicShape.concave,
                                  //         boxShape:
                                  //             NeumorphicBoxShape.roundRect(
                                  //                 BorderRadius.circular(30.r)),

                                  //         depth: 2,
                                  //         lightSource: LightSource.topLeft,
                                  //         color: ThemeColors.fig_pink),
                                  //     onPressed: () {},
                                  //     child: Center(
                                  //       child: TextCustom(
                                  //         text: "회원가입하러 가기",
                                  //         fontSize: 24.sp,
                                  //         color: Colors.white,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     )),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavigation(index: 4),
      ),
    );
  }
}
