import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
// import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:teentalktalk/domain/blocs/blocs.dart';
import 'package:teentalktalk/domain/services/auth_services.dart';
import 'package:teentalktalk/domain/services/event_services.dart';
import 'package:teentalktalk/ui/helpers/helpers.dart';
import 'package:teentalktalk/ui/helpers/kakao_sdk_login.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_basic.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_preparing.dart';
import 'package:teentalktalk/ui/screens/home/home_page.dart';
import 'package:teentalktalk/ui/screens/login/find_pw_page.dart';
import 'package:teentalktalk/ui/screens/login/find_id_page.dart';
import 'package:teentalktalk/ui/screens/register/terms_agree_page.dart';
import 'package:teentalktalk/ui/screens/register/user_type_page.dart';
import 'package:teentalktalk/ui/themes/theme_colors.dart';
import 'package:teentalktalk/ui/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController idController;
  late TextEditingController passwordController;
  late FocusNode idFocusNode;
  late FocusNode pwFocusNode;
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    passwordController = TextEditingController();
    idFocusNode = FocusNode();
    pwFocusNode = FocusNode();
  }

  @override
  void dispose() {
    if (mounted) {
      idController.clear();
      idController.dispose();
      passwordController.clear();
      passwordController.dispose();
      idFocusNode.unfocus();
      idFocusNode.dispose();
      pwFocusNode.unfocus();
      pwFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // print(state);
        // if (state is LoadingAuthentication) {
        //   modalLoading(context, '확인 중...');
        //   Navigator.of(context).pop();
        // } else

        if (state is SuccessAuthentication) {
          Navigator.pushAndRemoveUntil(
            context,
            routeFade(page: const HomePage()),
            (_) => false,
          );

          userBloc.add(OnGetUserAuthenticationEvent());
        } else if (state is FailureAuthentication) {
          modalWarning(context, '다시 로그인해주세요');
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: ThemeColors.primary),
              onPressed: () {
                Navigator.pop(context);

                // if (Navigator.canPop(context)) {
                //   Navigator.pop(context);
                // } else {
                //   Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const HomePage()));
                // }
              }),
        ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 40.0),
            child: SingleChildScrollView(
              child: Form(
                key: _keyForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30.0),
                    const Text('청소년 톡talk',
                        style: TextStyle(
                          color: ThemeColors.primary,
                          fontFamily: 'CookieRun',
                          fontSize: 20,
                        )),
                    const SizedBox(height: 10.0),

                    const TextCustom(
                      text: '나를 위한 맞춤 정책을\n관리해보세요',
                      maxLines: 2,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 30.0),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        'images/aco7.png',
                        width: 150.w,
                      ),
                    ),
                    // TextFieldNaru(
                    //   // enableInteractiveSelection: false,
                    //   controller: idController,
                    //   focusNode: idFocusNode,
                    //   hintText: '아이디 입력',
                    //   // keyboardType: TextInputType.emailAddress,
                    //   // validator: validatedEmail,
                    //   validator: RequiredValidator(errorText: '아이디를 입력해주세요'),
                    // ),
                    // const SizedBox(height: 10.0), // 비밀번호
                    // TextFieldNaru(
                    //   // enableInteractiveSelection: false,
                    //   controller: passwordController,
                    //   focusNode: pwFocusNode,
                    //   hintText: '비밀번호 입력',
                    //   isPassword: true,
                    //   validator: passwordValidator,
                    // ),
                    const SizedBox(height: 10.0),
                    // BtnNaru(
                    //   text: '로그인',
                    //   fontSize: 20,
                    //   height: 48,
                    //   width: size.width,
                    //   fontWeight: FontWeight.bold,
                    //   colorText: Colors.white,
                    //   onPressed: () {
                    //     if (_keyForm.currentState!.validate()) {
                    //       authBloc.add(OnLoginEvent(idController.text.trim(),
                    //           passwordController.text.trim()));
                    //     }
                    //   },
                    // ),
                    // BtnNaru(
                    //   text: '로그인하기',
                    //   fontSize: 20,
                    //   height: 48,
                    //   width: size.width,
                    //   fontWeight: FontWeight.bold,
                    //   colorText: Colors.white,
                    //   onPressed: () {
                    //     if (_keyForm.currentState!.validate()) {
                    //       authBloc.add(OnLoginEvent(idController.text.trim(),
                    //           passwordController.text.trim()));
                    //     }
                    //   },
                    // ),
                    // const SizedBox(height: 20.0),

                    // BtnNaru(
                    //   text: '카카오톡 로그인',
                    //   height: 48,
                    //   fontSize: 20,
                    //   width: size.width,
                    //   fontWeight: FontWeight.bold,
                    //   colorText: Colors.black,
                    //   // border: Border.all()
                    //   backgroundColor: Colors.yellow,
                    //   onPressed: () async {
                    //     bool loginSuccess =
                    //         await KakaoLoginServices.kakaoLogin();
                    //     if (loginSuccess) {
                    //       Map<String, String> userInfo =
                    //           await KakaoLoginServices.kakaoGetUserInfo();
                    //       // 카카오 계정 중복 체크
                    //       final bool isFirstKakaoLogin =
                    //           await authService.checkDuplicateID(
                    //               userInfo['user_id']!); // db에서 계정 중복 확인
                    //       if (!isFirstKakaoLogin) {
                    //         // 가입한 계정이 없으면 가입
                    //         // ignore: use_build_context_synchronously
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) =>
                    //                 const userTypePage(isKakaoLogin: true),
                    //           ),
                    //         );
                    //       } else {
                    //         // 가입한 계정이 있으면 로그인
                    //         authBloc.add(OnKakaoLoginEvent(
                    //             userInfo['user_id'] ?? '',
                    //             userInfo['user_email'] ?? ''));
                    //       }
                    //     }
                    //   },
                    // ),
                    TextButton(
                        onPressed: () async {
                          bool loginSuccess =
                              await KakaoLoginServices.kakaoLogin();
                          if (loginSuccess) {
                            Map<String, String> userInfo =
                                await KakaoLoginServices.kakaoGetUserInfo();
                            // 카카오 계정 중복 체크
                            final bool isFirstKakaoLogin =
                                await authService.checkDuplicateID(
                                    userInfo['user_id']!); // db에서 계정 중복 확인
                            if (!isFirstKakaoLogin) {
                              // 가입한 계정이 없으면 가입
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const userTypePage(isKakaoLogin: true),
                                ),
                              );
                            } else {
                              // 가입한 계정이 있으면 로그인
                              authBloc.add(OnKakaoLoginEvent(
                                  userInfo['user_id'] ?? '',
                                  userInfo['user_email'] ?? ''));
                            }
                          }
                        },
                        child: Center(
                          child: Container(
                            alignment: Alignment.center,
                            width: 320.w,
                            height: 50.h,
                            padding:
                                EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
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
                              text: "카카오톡으로 시작하기",
                              fontSize: 20.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),

                    const SizedBox(height: 5.0),

                    // const SizedBox(height: 60.0), // 비밀번호 찾기

                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       InkWell(
                    //           onTap: () {
                    //             // modalPreparing(context);
                    //             Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) => const FindIDPage(),
                    //                 ));
                    //           },
                    //           child: const TextCustom(text: '아이디 찾기')),
                    //       InkWell(
                    //           onTap: () {
                    //             // modalPreparing(context);
                    //             Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) =>
                    //                       const FindPasswordPage(),
                    //                 ));
                    //           },
                    //           child: const TextCustom(text: '비밀번호 찾기')),
                    //       InkWell(
                    //           onTap: () => Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (context) => const termsAgreePage(
                    //                   isKakaoLogin: false,
                    //                 ),
                    //               )),
                    //           child: const TextCustom(text: '회원가입'))
                    //     ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
