import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teentalktalk/domain/blocs/blocs.dart';
import 'package:teentalktalk/ui/helpers/get_mobile_code_data.dart';
import 'package:teentalktalk/ui/screens/event/enter_invite_code_page.dart';
import 'package:teentalktalk/ui/screens/home/home_page.dart';
import 'package:teentalktalk/ui/screens/policy/policy_detail_page.dart';
import 'package:teentalktalk/ui/screens/policy/policy_list_page.dart';
import 'package:teentalktalk/ui/screens/user/myTalkTalk_page.dart';
import 'package:teentalktalk/ui/themes/theme_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../helpers/animation_route.dart';

class CheckingLoginPage extends StatefulWidget {
  static const routeName = '/checking_login_page';
  const CheckingLoginPage({Key? key}) : super(key: key);

  @override
  State<CheckingLoginPage> createState() => _CheckingLoginPageState();
}

class _CheckingLoginPageState extends State<CheckingLoginPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    getMobileCodeService.getCodeData();
    getMobileCodeService.getEventData();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animationController.forward();
    _handleAuthState();
  }

  void _handleAuthState() {
    final userBloc = BlocProvider.of<UserBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);

    authBloc.stream.listen((state) {
      if (state is LogOut) {
        print(state);
        Navigator.pushAndRemoveUntil(
            context, routeFade(page: const HomePage()), (_) => false);
      } else if (state is SuccessAuthentication) {
        print(state);
        userBloc.add(OnGetUserAuthenticationEvent());
        Navigator.pushAndRemoveUntil(
            context, routeFade(page: const HomePage()), (_) => false);
      }

      if (mounted) {
        _initDynamicLinks(); // 로그인/아웃 상태 처리 후 다이나믹 링크 이동 함수 호출
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _initDynamicLinks();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink;

    // 앱이 처음 시작될 때 동적 링크 처리
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    // print('_initDynamicLinks : $deepLink');

    if (deepLink != null) {
      _handleDynamicLink(deepLink);
    }
  }

  void _handleDynamicLink(Uri deepLink) {
    // 정책 링크로 접근
    // 딥링크의 경로가 비어 있지 않고, 첫 번째 경로 세그먼트가 'policy'와 일치하는지 확인
    if (deepLink.pathSegments.isNotEmpty &&
        deepLink.pathSegments.first == 'policy') {
      final Map<String, String> queryParams = deepLink.queryParameters;
      final String? policyId = queryParams['policyId'];

      // 정책 ID가 존재하는 경우에만 정책 상세 페이지로 이동
      if (policyId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PolicyListPage(
              policyId: policyId,
              selectedCodes: SelectedCodes(
                policyInstitution: [],
                policyTarget: [],
                policyField: [],
                policyCharacter: [],
              ),
            ),
          ),
        );
      } else if (deepLink.pathSegments.isNotEmpty &&
          deepLink.pathSegments.first == 'invitation') {
        final Map<String, String> queryParams = deepLink.queryParameters;
        final String? invite_code = queryParams['code'];
        // print(invite_code);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyTalkTalkPage(),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColors.primary,
        body: Center(
          child: SvgPicture.asset(
            'images/icon_logo.svg',
          ),
        ));
  }
}


// Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             decoration: const BoxDecoration(
//                 color: Colors.red,
//                 gradient: LinearGradient(
//                     begin: Alignment.bottomCenter,
//                     colors: [
//                       ThemeColors.secondary,
//                       ThemeColors.primary,
//                       Colors.white
//                     ])),
//             child: Container())



// return BlocListener<AuthBloc, AuthState>(
    //   listener: (context, state) {
    //     // print(state);

    //     if (state is LogOut) {
    //       print(state);
    //       Navigator.pushAndRemoveUntil(
    //           context, routeFade(page: const HomePage()), (_) => false);
    //     } else if (state is SuccessAuthentication) {
    //       print(state);
    //       userBloc.add(OnGetUserAuthenticationEvent());
    //       Navigator.pushAndRemoveUntil(
    //           context, routeFade(page: const HomePage()), (_) => false);
    //     }
    //   },
    //   child: Scaffold(
    //       body: Container(
    //           height: MediaQuery.of(context).size.height,
    //           width: MediaQuery.of(context).size.width,
    //           decoration: const BoxDecoration(
    //               color: Colors.red,
    //               gradient: LinearGradient(
    //                   begin: Alignment.bottomCenter,
    //                   colors: [
    //                     ThemeColors.secondary,
    //                     ThemeColors.primary,
    //                     Colors.white
    //                   ])),
    //           child: Container())),

    // SizedBox(
    //   height: MediaQuery.of(context).size.height,
    //   width: MediaQuery.of(context).size.width,
    //   child: Image.asset(
    //     'images/Splash.jpg',
    //     fit: BoxFit.fill,
    //   ),
    // child: SvgPicture.asset(
    //   'images/Splash.svg',
    //   fit: BoxFit.fill,
    // )

    // decoration: const BoxDecoration(
    //   color: Colors.red,
    //   gradient: LinearGradient(begin: Alignment.bottomCenter, colors: [
    //     ThemeColors.secondary,
    //     ThemeColors.primary,
    //     Colors.white
    //   ]),
    // ),
    // Center(
    //   child: SizedBox(
    //     height: 200,
    //     width: 150,

    // child: Column(
    //   children: [
    //     AnimatedBuilder(
    //         animation: _animationController,
    //         builder: (_, child) => Transform.scale(
    //               scale: _scaleAnimation.value,
    //               // child: Image.asset('assets/img/yeongam_logo.jpeg')
    //             )),
    //     const SizedBox(height: 10.0),
    //     const TextCustom(text: '확인중...', color: Colors.black)
    //   ],
    // ),
    // ),