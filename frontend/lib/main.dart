// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:teentalktalk/domain/blocs/blocs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teentalktalk/ui/helpers/firebase_messaging.dart';
import 'package:teentalktalk/ui/screens/intro/checking_login_page.dart';
import 'firebase_options.dart';

void main() async {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  // runApp()호출 전 Flutter SDK 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase DynamicLink
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Firebase Messaging 초기화
  // await FirebaseMessagingService.initializeFirebaseMessaging();
  // await FirebaseMessagingService.requestFirebaseNotificationPermission();
  // String? fcmToken = await FirebaseMessagingService.getFirebaseToken();
  // print('FCM 토큰: $fcmToken');

  // Kakao SDK
  KakaoSdk.init(
    nativeAppKey: '5d2af2be00c43b9170c3c6dc5c6fd661', // 앱 키
    // javaScriptAppKey: '${YOUR_JAVASCRIPT_APP_KEY}',
    loggingEnabled: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    // with WidgetsBindingObserver와 함께 foreground 동적링크를 위한 추가
    // 앱이 완전히 종료되었을 때
    // 링크 클릭해서 앱이 실행되는 경우와
    // 앱이 백그라운드 상태에 있다가 링크를 클릭해서 앱으로 돌아오는 경우 모두 작동해야 함
    // 백그라운드 상태에서 앱으로 돌아오게 하기 위해 Observer 추가
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    // final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;

    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (_) => AuthBloc()..add(OnCheckingLoginEvent())),
              BlocProvider(create: (_) => UserBloc()),
              BlocProvider(create: (_) => PolicyBloc()),
            ],
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: ' 영암군 청소년 복지 정책 제공',
                home: CheckingLoginPage()),
          );
        });
  }
}
