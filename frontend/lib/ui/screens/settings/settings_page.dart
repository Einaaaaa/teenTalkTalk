import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teentalktalk/domain/blocs/auth/auth_bloc.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_checkLogin.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_preparing.dart';
import 'package:teentalktalk/ui/screens/settings/notice_page.dart';
import 'package:teentalktalk/ui/screens/settings/service_center_page.dart';
import 'package:teentalktalk/ui/screens/settings/terms_page.dart';
import 'package:teentalktalk/ui/screens/settings/withdrawal_page.dart';
import 'package:teentalktalk/ui/themes/theme_colors.dart';
import 'package:teentalktalk/ui/widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = BlocProvider.of<AuthBloc>(context).state;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: const TextCustom(
              text: '설정',
              color: ThemeColors.basic,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ThemeColors.primary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Column(children: [
              // Container(
              //   padding: const EdgeInsets.all(30),
              //   child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Icon(
              //           Icons.notifications_none_rounded,
              //           size: 30.sp,
              //         ),
              //         SizedBox(
              //           width: 5.w,
              //         ),
              //         TextCustom(
              //           text: "알림 허용",
              //           fontSize: 20.sp,
              //           fontWeight: FontWeight.bold,
              //         ),
              //         const Spacer(),
              //         const _NotifySwitchButton()
              //       ]),
              // ),
              // Container(
              //   height: 2.h,
              //   color: Colors.grey[200],
              // ),
              // ListTile(
              //   contentPadding: const EdgeInsets.only(left: 30, right: 30),
              //   title: TextCustom(
              //     text: "공지 사항",
              //     fontSize: 18.sp,
              //   ),
              //   trailing: const Icon(
              //     Icons.arrow_forward_ios_rounded,
              //     color: ThemeColors.basic,
              //   ),
              //   onTap: () {
              //     // modalPreparing(context);
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const NoticePage(),
              //         ));
              //   },
              // ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 30, right: 30),
                title: TextCustom(
                  text: "고객 센터",
                  fontSize: 18.sp,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ThemeColors.basic,
                ),
                onTap: () {
                  if (authState is LogOut) {
                    modalCheckLogin(context);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ServiceCenterPage(),
                        ));
                  }
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 30, right: 30),
                title: TextCustom(
                  text: "서비스 이용약관",
                  fontSize: 18.sp,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ThemeColors.basic,
                ),
                onTap: () {
                  // modalPreparing(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServiceTermsPage(),
                      ));
                },
              ),
              Container(
                height: 2.h,
                color: Colors.grey[200],
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 30, right: 30),
                title: TextCustom(
                  text: "버전 관리",
                  fontSize: 18.sp,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ThemeColors.basic,
                ),
                onTap: () {
                  modalPreparing(context);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => const NoticePage(),
                  //     ));
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 30, right: 30),
                title: TextCustom(
                  text: "회원 탈퇴",
                  fontSize: 18.sp,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ThemeColors.basic,
                ),
                onTap: () {
                  if (authState is LogOut) {
                    modalCheckLogin(context);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WithdrawalPage(),
                        ));
                  }
                },
              ),
            ]),
          ),
        ));
  }
}

class _NotifySwitchButton extends StatefulWidget {
  const _NotifySwitchButton();

  @override
  State<_NotifySwitchButton> createState() => _NotifySwitchButtonState();
}

class _NotifySwitchButtonState extends State<_NotifySwitchButton> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return NeumorphicSwitch(
      value: light,
      height: 35.h,
      style: NeumorphicSwitchStyle(
        activeTrackColor: ThemeColors.primary,
        inactiveTrackColor: Colors.grey[300],
      ),
      onChanged: (bool value) {
        setState(() {
          light = value;
        });
      },
    );

    // Switch(
    //   // This bool value toggles the switch.
    //   value: light,
    //   activeColor: ThemeColors.primary,
    //   onChanged: (bool value) {
    //     // This is called when the user toggles the switch.
    //     setState(() {
    //       light = value;
    //     });
    //   },
    // );
  }
}
