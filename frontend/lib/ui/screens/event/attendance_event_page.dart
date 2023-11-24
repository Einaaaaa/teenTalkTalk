import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:teentalktalk/ui/helpers/attendance_event_controller.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_getFig.dart';
import 'package:teentalktalk/ui/themes/theme_colors.dart';
import 'package:teentalktalk/ui/widgets/widgets.dart';

class AttendanceEventPage extends StatefulWidget {
  const AttendanceEventPage({Key? key}) : super(key: key);

  @override
  State<AttendanceEventPage> createState() => _AttendanceEventPageState();
}

class _AttendanceEventPageState extends State<AttendanceEventPage> {
  static DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    EventController controller = EventController();

    final size = MediaQuery.of(context).size;
    controller.onInit();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: ThemeColors.primary,
        appBar: AppBar(
          backgroundColor: ThemeColors.primary,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: SingleChildScrollView(
          physics:
              const ClampingScrollPhysics(), //const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("images/event_icon/attendance_icon.svg",
                        color: Colors.white, height: 40.h, width: 40.w),
                    TextCustom(
                        text: "${now.month}월",
                        fontSize: 30.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextCustom(
                    text: "매일 출석체크하고 무화과를 모아요",
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600),
                SizedBox(
                  height: 5.h,
                ),
                TextCustom(
                    text: "2023.10.01 ~ 2023.10.31",
                    color: Colors.white,
                    fontSize: 12.sp),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  // height: MediaQuery.of(context).size.height.h / 1.34.h,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 28.h,
                      ),
                      Obx(
                        () => Column(
                          children: [
                            TextCustom(
                                text: "출석 횟수",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500),
                            SizedBox(
                              height: 5.h,
                            ),
                            TextCustom(
                                text: controller.temp_days.length.toString(),
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 28.h,
                      ),
                      SizedBox(
                        width: 350,
                        // margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < controller.week.length; i++)
                              Container(
                                width: 30,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextCustom(
                                  text: controller.week[i],
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: i == 0
                                      ? ThemeColors.primary
                                      : i == controller.week.length - 1
                                          ? ThemeColors.primary
                                          : ThemeColors.primary,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      SizedBox(
                        width: 350,
                        child: Obx(
                          () => Wrap(
                            children: [
                              for (var i = 0; i < controller.days.length; i++)
                                if (controller.days[i]['month'] ==
                                        controller.now2.value.month &&
                                    controller.temp_days.contains(
                                        controller.days[i]['day'])) ...[
                                  Container(
                                    width: 30,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: controller.days[i]["picked"].value
                                          ? Colors.red
                                          : Colors.transparent,
                                    ),
                                    child: Center(
                                        child:

                                            // SvgPicture.asset('images/Fig2.svg', width: 18.w,height: 18.h,)
                                            Image.asset(
                                      'images/Fig2.png',
                                      width: 17.w,
                                      height: 17.h,
                                    )),
                                  ),
                                ] else ...[
                                  Container(
                                    width: 30,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: controller.days[i]["picked"].value
                                          ? Colors.red
                                          : Colors.transparent,
                                    ),
                                    child: Center(
                                      child: TextCustom(
                                        text: controller.days[i]["day"]
                                            .toString(),
                                        fontSize: 15.sp,
                                        color: controller.days[i]["inMonth"]
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ]
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 190.w,
                        child: NeumorphicButton(
                          margin: EdgeInsets.only(top: 10.h),
                          style: NeumorphicStyle(
                              // disableDepth: controller.isCheckedAttendance.value
                              //     ? true
                              //     : false,
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(50.r)),
                              depth: 2,
                              lightSource: LightSource.topLeft,
                              color: controller.isCheckedAttendance.value
                                  ? Colors.grey
                                  : const Color.fromRGBO(247, 248, 250, 1)),
                          onPressed: () {
                            controller.handleAttendanceCheck(context);
                          },
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SvgPicture.asset('images/Fig.svg',
                              //     width: 18.w, height: 18.h),
                              Image.asset(
                                'images/Fig2.png',
                                width: 20.w,
                                height: 20.h,
                              ),
                              SizedBox(width: 8.w),
                              TextCustom(
                                text: "오늘의 무화과 받기",
                                fontSize: 15.sp,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 5.h,
                        margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(247, 248, 250, 1),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 22.w),
                          child: TextCustom(
                              text: "유의사항",
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 100.h,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
