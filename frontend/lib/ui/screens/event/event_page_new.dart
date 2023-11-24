import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:teentalktalk/domain/blocs/blocs.dart';
import 'package:teentalktalk/domain/models/response/response_user_fig_count.dart';
import 'package:teentalktalk/domain/services/event_services.dart';
import 'package:teentalktalk/domain/services/user_services.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_checkLogin.dart';
import 'package:teentalktalk/ui/screens/event/attendance_event_page.dart';
import 'package:teentalktalk/ui/screens/event/invite_event_page.dart';
import 'package:teentalktalk/ui/screens/event/weekly_fig_mission/01_week_page.dart';
import 'package:teentalktalk/ui/screens/event/weekly_fig_mission/02_week_page.dart';
import 'package:teentalktalk/ui/screens/event/weekly_fig_mission/03_week_page.dart';
import 'package:teentalktalk/ui/themes/theme_colors.dart';
import 'package:teentalktalk/ui/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => EventPageState();
}

class EventPageState extends State<EventPage> {
  late bool hasWeek01Participated = false; // 회원가입
  late bool hasWeek02Participated = false; // 정책 스크랩
  late bool hasWeek03Participated = false; // 정책 공유

  final surveyLink = Uri.parse(
      'https://docs.google.com/forms/d/e/1FAIpQLScFYiMm6znW_w56dDHghu7MNxEL74ffaT0wYS02diT12AUHnQ/viewform');

  late String figCount = '-';

  Future<void> _updateFigCount() async {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    if (authBloc.state is SuccessAuthentication) {
      ResponseUserFigCount figCountData = await userService.updateFigCount();
      setState(() {
        figCount = figCountData.figCount;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final authState = BlocProvider.of<AuthBloc>(context).state;
    _updateFigCount();
    if (authState is SuccessAuthentication) {
      checkEventParticipation();
    }
  }

  Future<void> checkEventParticipation() async {
    // true -> 참여 기록 없음. 참여 가능
    // false -> 참여 기록 있음. 참여 불가능
    var week01 = await eventService.checkEventParticipation('2'); // 회원가입
    var week02 = await eventService.checkEventParticipation('3'); // 정책 스크랩
    var week03 = await eventService.checkEventParticipation('4'); // 정책 공유
    // var week04 = await eventService.checkEventParticipation('5');

    print(week01);
    setState(() {
      hasWeek01Participated = !week01.resp;
      hasWeek02Participated = !week02.resp;
      hasWeek03Participated = !week03.resp;
      // hasWeek04Participated = !week04.resp;
    });
    // print(hasWeek01Participated);
  }

  @override
  Widget build(BuildContext context) {
    final authState = BlocProvider.of<AuthBloc>(context).state;

    // 이벤트 참여 여부
    List<bool> getWeekCheckList = [
      hasWeek01Participated, // 회원가입
      hasWeek02Participated, // 정책 스크랩
      hasWeek03Participated, // 정책 공유
      // hasWeek04Participated
    ];

    List<String> challengeList = [
      "하루 한 번, 출석 체크하고 무화과 받기",
      "친구 초대하고 함께 무화과 받기",
      "청소년 톡talk 가입하고 무화과 받기",
      "꾹~ 정책 스크랩하고 무화과 받기",
      "너도 해봐! 정책 공유하고 무화과 받기"
    ];

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            titleSpacing: 0,
            title: const Text(
              '이벤트',
              style: TextStyle(
                color: ThemeColors.primary,
                fontFamily: 'CookieRun',
                fontSize: 24,
              ),
            ),
            leading: InkWell(
              // onTap: () => Navigator.push(context, routeSlide(page: const LoginPage())),
              child: Image.asset(
                'images/aco.png',
                height: 70,
              ),
            ),
            backgroundColor: Colors.white, //ThemeColors.primary,
            centerTitle: false,
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(0, 40.h, 0, 20.h),
            child: Center(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StrokeText(
                      text: "미션",
                      textStyle: TextStyle(
                          fontSize: 50.sp,
                          letterSpacing: 5,
                          fontFamily: 'BMJUA',
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.basic),
                      strokeColor: Colors.transparent,
                      // strokeWidth: 2,
                    ),
                    StrokeText(
                      text: " 참여하고",
                      textStyle: TextStyle(
                          fontSize: 50.sp,
                          letterSpacing: 5,
                          fontFamily: 'BMJUA',
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.primary),
                      strokeColor: Colors.transparent,
                      // strokeWidth: 2,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StrokeText(
                      text: "무화과",
                      textStyle: TextStyle(
                          fontSize: 50.sp,
                          letterSpacing: 5,
                          fontFamily: 'BMJUA',
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.primary),
                      strokeColor: Colors.transparent,
                      // strokeWidth: 2,
                    ),
                    StrokeText(
                      text: " 모으자",
                      textStyle: TextStyle(
                          fontSize: 50.sp,
                          letterSpacing: 5,
                          fontFamily: 'BMJUA',
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.basic),
                      strokeColor: Colors.transparent,
                      // strokeWidth: 2,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10.w, 7.h, 10.w, 7.h),
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(
                          245, 117, 33, 0.8), //ThemeColors.primary,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: TextCustom(
                    text: '이벤트 기간 : 12/1 ~ 12/14',
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                SvgPicture.asset(
                  "images/event/event_namsaeng.svg",
                ),

                SizedBox(
                  height: 40.h,
                ),
                SvgPicture.asset(
                  "images/event/event_info1.svg",
                ),
                SizedBox(
                  height: 10.h,
                ),

                // 무화과 개수 표시
                buildFigCountWidget(),

                Icon(
                  Icons.keyboard_double_arrow_down_rounded,
                  color: ThemeColors.primary,
                  size: 88.h,
                ),
                SizedBox(
                  height: 10.h,
                ),

                // 미션 안내
                // 미션1 - 출석체크
                challengeWidget(
                  num: 1,
                  text: challengeList[0],
                  // imagePath: 'images/event_icon/icon_01.svg',
                  iconData: Icons.calendar_month_rounded,
                  color: Color.fromRGBO(134, 198, 227, 1),
                ),
                SizedBox(height: 27.h),

                // 미션2 - 친구초대
                challengeWidget(
                  num: 2,
                  text: challengeList[1],
                  // imagePath: 'images/event_icon/icon_02.svg',
                  iconData: Icons.person_add,
                  color: Color.fromRGBO(126, 181, 84, 1),
                ),
                SizedBox(height: 27.h),
                // 미션3 - 회원가입
                challengeWidget(
                    num: 3,
                    text: challengeList[2],
                    // imagePath: 'images/event_icon/icon_03.svg',
                    iconData: Icons.person_pin_outlined,
                    color: Color.fromRGBO(212, 113, 125, 1),
                    isCheck: getWeekCheckList[0]),
                SizedBox(height: 27.h),
                // 미션4 - 정책 스크랩
                challengeWidget(
                    num: 4,
                    text: challengeList[3],
                    // imagePath: 'images/event_icon/icon_04.svg',
                    iconData: Icons.bookmark_add_outlined,
                    color: Color.fromRGBO(244, 209, 77, 1),
                    isCheck: getWeekCheckList[1]),
                SizedBox(height: 27.h),
                // 미션5 - 정책 공유
                challengeWidget(
                    num: 5,
                    text: challengeList[4],
                    // imagePath: 'images/event_icon/icon_05.svg',
                    iconData: Icons.share,
                    color: Color.fromRGBO(180, 114, 192, 1),
                    isCheck: getWeekCheckList[2]),
                SizedBox(height: 27.h),

                // 이벤트 참여 방법 안내
                Container(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Divider(
                          color: ThemeColors.primary,
                          height: 30.h,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TextCustom(
                          text: '<이벤트 참여 방법>',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: ThemeColors.primary,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextCustom(
                          text: '1. 앱을 사용하며 무화과 30개 모으기',
                          fontSize: 15.sp,
                          // color: ThemeColors.basic,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TextCustom(
                          text: '2. 만족도 조사에서 앱 사용 후기 남기기',
                          fontSize: 15.sp,
                          // color: ThemeColors.basic,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        TextCustom(
                          text: '3. 아래 이벤트 참여하기 버튼 클릭하기',
                          fontSize: 15.sp,
                          // color: ThemeColors.basic,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        TextCustom(
                          text:
                              '이벤트 참여와 함께 만족도 조사에도 꼭 참여해주세요.\n두 가지를 모두 완료해야만 상품을 받을 수 있습니다.',
                          fontSize: 12.sp,
                          maxLines: 2,
                          height: 1.2.h,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.basic,
                        ),
                      ]),
                ),

                SizedBox(
                  height: 10.h,
                ),

                // 만족도 조사 말풍선 + 아코
                InkWell(
                    onTap: () {
                      // 만족도 조사 구글폼 링크 연결
                      launchUrl(
                        surveyLink,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "images/event/event_survey.svg",
                        ),
                        Column(
                          children: [
                            Container(
                              height: 70.h,
                            ),
                            Image.asset(
                              'images/aco5.png',
                              height: 70,
                            ),
                          ],
                        )
                      ],
                    )),

                // 이벤트 참여하기 버튼
                TextButton(
                    onPressed: () {
                      // 로그인 O
                      if (authState is SuccessAuthentication) {
                        // 무화과 개수 불러와서 30개 이상인지 판단
                        // 30개 이상이면 이벤트 참여 완료되었습니다! modal 띄우고 버튼 텍스트 '참여 완료'로 바꾸기
                        // 30개 미만이면 modal - '무화과를 더 모아주세요'
                        // 참여 완료 상태에서 버튼 누르면 modal - '이미 참여하였습니다. 만족도 조사는 하셨나요? 만족도 조사까지 해야 상품을 받을 수 있어요!' 등
                      } else {
                        // 로그인 X
                        modalCheckLogin(context);
                      }
                    },
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        width: 310.w,
                        height: 50.h,
                        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(
                                245, 117, 33, 0.8), //ThemeColors.fig_pink,
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
                          text: "이벤트 참여하기",
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
              ],
            )),
          ),
          bottomNavigationBar: const BottomNavigation(index: 4),
        ));
  }

  Widget buildFigCountWidget() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(30.sp),
        padding: EdgeInsets.all(20.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextCustom(
              text: '나의 무화과',
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextCustom(
                  text: figCount,
                  fontSize: 40,
                  color: ThemeColors.basic,
                  fontWeight: FontWeight.bold,
                ),
                Image.asset(
                  'images/Fig2.png',
                  height: 50.h,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget challengeWidget({
    required int num, // 미션 번호
    required String text, // 이벤트 제목
    required IconData iconData,
    required Color color,
    // required String imagePath, // 아이콘 경로
    bool isCheck = false, // 이벤트 참여 여부
  }) {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (!isCheck) {
      return InkWell(
        onTap: () {
          // 해당 주차 페이지로 이동
          switch (num) {
            case 1:
              if (authState is SuccessAuthentication) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendanceEventPage(),
                    ));
              } else {
                modalCheckLogin(context);
              }

              break;
            case 2:
              if (authState is SuccessAuthentication) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InviteEventPage(),
                    ));
              } else {
                modalCheckLogin(context);
              }
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FirstWeekMissionPage(hasParticipated: isCheck),
                ),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SecondWeekMissionPage(hasParticipated: isCheck),
                ),
              );
              break;
            case 5:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ThirdWeekMissionPage(hasParticipated: isCheck),
                ),
              );
              break;

            default:
              // 기본적으로 첫주차 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FirstWeekMissionPage(hasParticipated: isCheck),
                ),
              );
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          width: 300.w,
          height: 50.h,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 2.w),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SvgPicture.asset(imagePath, width: 30.w),
                Icon(
                  iconData,
                  color: color,
                  size: 30,
                ),

                TextCustom(
                  text: text,
                  color: Colors.black,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: color,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            width: 300.w,
            height: 50.h,
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 2.w),
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SvgPicture.asset(imagePath, width: 30.w),
                  Icon(
                    iconData,
                    color: color,
                    size: 30,
                  ),
                  TextCustom(
                    text: text,
                    color: Colors.black,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: color,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 300.w,
            height: 50.h,
            decoration: BoxDecoration(
              border: Border.all(color: ThemeColors.basic, width: 2.w),
              color: Color.fromARGB(175, 104, 101, 99),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: TextCustom(
                    text: "완료",
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                )),
          )
        ],
      );
    }
  }
}
