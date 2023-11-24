// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:teentalktalk/domain/blocs/blocs.dart';
// import 'package:teentalktalk/ui/helpers/modals/modal_checkLogin.dart';
// import 'package:teentalktalk/ui/screens/event/attendance_event_page.dart';
// import 'package:teentalktalk/ui/screens/event/event_list_page.dart';
// import 'package:teentalktalk/ui/screens/event/new_weeklyFig_event_page.dart';
// import 'package:teentalktalk/ui/screens/event/weeklyFig_event_page.dart';
// import 'package:teentalktalk/ui/themes/theme_colors.dart';
// import 'package:teentalktalk/ui/widgets/widgets.dart';

// class EventPage extends StatelessWidget {
//   const EventPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: ThemeColors.third,
//         appBar: AppBar(
//           titleSpacing: 0,
//           title: const Text(
//             '이벤트',
//             style: TextStyle(
//               color: ThemeColors.primary,
//               fontFamily: 'CookieRun',
//               fontSize: 24,
//             ),
//           ),
//           leading: InkWell(
//             // onTap: () => Navigator.push(context, routeSlide(page: const LoginPage())),
//             child: Image.asset(
//               'images/aco.png',
//               height: 70,
//             ),
//           ),
//           backgroundColor: Colors.white, //ThemeColors.primary,
//           centerTitle: false,
//           elevation: 0.0,
//         ),
//         body: Column(
//           children: <Widget>[
//             Expanded(
//               child: ListView(
//                 shrinkWrap: true,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
//                     child: Center(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // const SizedBox(height: 10),
//                           // Center(
//                           //     child: Column(
//                           //   children: [
//                           //     Image.asset(
//                           //       'images/aco2.png',
//                           //       width: 300,
//                           //       height: 300,
//                           //     ),
//                           //     const TextCustom(text: '준비중입니다!', fontSize: 20),
//                           //   ],
//                           // ))
//                           const _attendanceEvent(),
//                           SizedBox(height: 16.h),
//                           const _weeklyFigEvent(),
//                           SizedBox(height: 16.h),
//                           InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const EventListPage(),
//                                   ));
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 TextCustom(
//                                     text: "무화과 이벤트 모두 보기",
//                                     color: ThemeColors.basic,
//                                     fontSize: 12.sp),
//                                 SizedBox(width: 4.w),
//                                 const Icon(
//                                   Icons.arrow_forward_ios_rounded,
//                                   size: 12,
//                                   color: ThemeColors.basic,
//                                 )
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 16.h),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         bottomNavigationBar: const BottomNavigation(index: 4),
//       ),
//     );
//   }
// }

// class _attendanceEvent extends StatelessWidget {
//   const _attendanceEvent();

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final authState = BlocProvider.of<AuthBloc>(context).state;

//     return SizedBox(
//       height: 80.h,
//       width: size.width,
//       // margin: EdgeInsets.only(left: 12.w, right: 12.w),
//       child: InkWell(
//         onTap: () {
//           if (authState is SuccessAuthentication) {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const AttendanceEventPage(),
//                 ));
//           } else {
//             modalCheckLogin(context);
//           }
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: 1,
//                 blurRadius: 5,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(30.r),
//           ),
//           child: Container(
//             margin: EdgeInsets.only(left: 24.w, right: 24.w),
//             child: Row(
//               children: [
//                 TextCustom(
//                   text: "하루 한 번, 출석 체크하고 \n무화과 받기",
//                   maxLines: 2,
//                   height: 1.3.h,
//                   color: Colors.black,
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 const Spacer(),
//                 SvgPicture.asset('images/event_icon/attendance_icon.svg')
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _weeklyFigEvent extends StatelessWidget {
//   const _weeklyFigEvent();

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return SizedBox(
//       height: 80.h,
//       width: size.width,
//       // margin: EdgeInsets.only(left: 12.w, right: 12.w),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const NewWeeklyFigEventPage(),
//               ));
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: 1,
//                 blurRadius: 5,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(30.r),
//           ),
//           child: Container(
//             margin: EdgeInsets.only(left: 24.w, right: 24.w),
//             child: Row(
//               children: [
//                 TextCustom(
//                   text: "주간 무화과 챌린지\n이번주 미션은?",
//                   color: Colors.black,
//                   height: 1.3.h,
//                   maxLines: 2,
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 const Spacer(),
//                 SvgPicture.asset('images/event_icon/flagIcon.svg')
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
