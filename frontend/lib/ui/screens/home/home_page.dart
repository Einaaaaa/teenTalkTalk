import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/domain/models/response/response_user.dart';
import 'package:login/ui/screens/login/login_page.dart';
import 'package:login/ui/helpers/helpers.dart';
import 'package:login/domain/blocs/blocs.dart';
import 'package:login/ui/themes/theme_colors.dart';
import 'package:login/ui/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userBloc = BlocProvider.of<UserBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('청소년톡talk',
              style: TextStyle(color: Colors.black, fontSize: 20)),
          leading: IconButton(
            icon: const Icon(Icons.perm_identity),
            onPressed: () =>
                Navigator.push(context, routeSlide(page: const LoginPage())),
          ),
          backgroundColor: ThemeColors.primary,
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50.0),
                const TextCustom(
                    text: 'MainPage',
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    color: ThemeColors.secondary),
                const SizedBox(height: 30.0),
                BtnNaru(
                  text: '로그아웃',
                  colorText: Colors.black,
                  width: size.width,
                  onPressed: () {
                    authBloc.add(OnLogOutEvent());
                    userBloc.add(OnLogOutUser());
                    Navigator.pushAndRemoveUntil(context,
                        routeSlide(page: const LoginPage()), (_) => false);
                  },
                ),
                const SizedBox(height: 30.0),
                // BtnNaru(
                //   text: '마이페이지',
                //   backgroundColor: ThemeColors.secondary,
                //   colorText: Colors.white,
                //   width: size.width,
                //   onPressed: () =>
                //       Navigator.push(context, routeSlide(page: MyView())),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
