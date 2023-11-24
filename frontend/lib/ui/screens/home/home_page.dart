import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teentalktalk/data/env/env.dart';
import 'package:teentalktalk/domain/blocs/auth/auth_bloc.dart';
import 'package:teentalktalk/domain/blocs/user/user_bloc.dart';
import 'package:teentalktalk/domain/models/response/response_policy.dart';
import 'package:teentalktalk/domain/services/event_services.dart';
import 'package:teentalktalk/domain/services/policy_services.dart';
import 'package:teentalktalk/ui/helpers/helpers.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_event.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_getFig.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_logout.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_preparing.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_scrap.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_success_register.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_unscrap.dart';
import 'package:teentalktalk/ui/screens/event/new_weeklyFig_event_page.dart';
import 'package:teentalktalk/ui/screens/login/no_login_page.dart';
import 'package:teentalktalk/ui/screens/notification/notification_page.dart';
import 'package:teentalktalk/ui/screens/policy/policy_detail_page.dart';
import 'package:teentalktalk/ui/screens/policy/policy_list_page.dart';
import 'package:teentalktalk/ui/screens/user/myTalkTalk_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:teentalktalk/domain/models/response/response_banner.dart';
import 'package:teentalktalk/domain/services/banner_services.dart';
import 'package:teentalktalk/ui/screens/login/login_page.dart';
import 'package:teentalktalk/ui/themes/theme_colors.dart';
import 'package:teentalktalk/ui/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isEventParticipationAvailable = false;

  @override
  void initState() {
    super.initState();
    final authState = BlocProvider.of<AuthBloc>(context).state;

    // if (authState is SuccessAuthentication) {
    //   checkEventParticipation();
    // }
  }

  void dispose() {
    super.dispose();
  }

  Future<void> checkEventParticipation() async {
    var response = await eventService.checkEventParticipation('2');
    setState(() {
      isEventParticipationAvailable = response.resp;
    });
    // navigateToEventPage();
  }

  void navigateToEventPage() {
    // print(isEventParticipationAvailable);
    if (isEventParticipationAvailable) {
      modalEvent(context,
          onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NewWeeklyFigEventPage()),
              ));
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const newWeeklyFigEventPage()),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final userBloc = BlocProvider.of<UserBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);
    // final authState = BlocProvider.of<AuthBloc>(context).state;

    // if (authState is SuccessAuthentication) {
    //   checkEventParticipation();
    // }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ThemeColors.third,
          appBar: AppBar(
            titleSpacing: 0,
            title: Text('청소년 톡talk',
                style: TextStyle(
                  color: ThemeColors.primary,
                  fontFamily: 'CookieRun',
                  fontSize: 20.sp,
                )),
            leading: InkWell(
              child: Image.asset('images/aco.png', height: 55.h),
            ),
            actions: [
              Row(children: [
                IconButton(
                    icon: Icon(
                      Icons.notifications_none_outlined,
                      size: 25.w,
                      color: ThemeColors.primary,
                    ),
                    onPressed: () {
                      modalPreparing(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const NotificationPage()));
                    }),
                IconButton(
                    icon: Icon(
                      Icons.perm_identity,
                      size: 25.w,
                      color: ThemeColors.primary,
                    ),
                    padding: const EdgeInsets.only(right: 20),
                    onPressed: () {
                      if (authBloc.state is LogOut) {
                        // 로그인 상태가 아닐 경우 LoginPage로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      } else {
                        // 로그인 상태일 경우 MyPage로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyTalkTalkPage()),
                        );
                      }
                    }),
              ])
            ],
            backgroundColor: Colors.white, //ThemeColors.primary,
            centerTitle: false,
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  // const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                  // const EdgeInsets.all(15),
                  const EdgeInsets.fromLTRB(15, 20, 15, 20).w,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 배너 슬라이드
                  FutureBuilder<List<Banners>>(
                    future: bannerService.getBannerData(),
                    builder: (_, snapshot) {
                      if (snapshot.data != null && snapshot.data!.isEmpty) {
                        return _ListWithoutBanner();
                      }

                      return !snapshot.hasData
                          ? Column(
                              children: const [ShimmerNaru(), ShimmerNaru()],
                            )
                          : CarouselSlider.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: ((context, index, realIndex) =>
                                  BannerSlide(
                                      policyBanners: snapshot.data![index])),
                              options: CarouselOptions(
                                scrollDirection: Axis.horizontal,
                                height: MediaQuery.of(context).size.height / 4,
                                enlargeCenterPage: true,
                                viewportFraction: 1.0,
                                autoPlay: true,
                              ),
                            );
                    },
                  ),

                  SizedBox(
                    height: 15.h,
                  ),

                  // 생애주기별 정책
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1.r,
                            blurRadius: 5.r,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(15).w,
                      // margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                      child: Column(children: [
                        Row(children: [
                          Icon(
                            Icons.auto_graph_rounded,
                            color: ThemeColors.primary,
                            size: 22.w,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          TextCustom(
                            text: '생애주기별 영암군 정책을 확인하세요!',
                            color: Colors.black, //ThemeColors.basic,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ]),
                        SizedBox(
                          width: 5.w,
                        ),
                        // 생애주기별 카테고리 아이콘
                        const CategoryButton(),
                      ])),
                  SizedBox(
                    height: 15.h,
                  ),

                  // 실시간 인기글
                  Container(
                    // height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1.r,
                          blurRadius: 5.r,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(15).w,
                    // margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                    child: InkWell(
                        // onTap: () => Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const PolicyListPage(
                        //         codeName: '',
                        //         codeDetail: '',
                        //       ), // 복지검색 탭
                        //     )),
                        child: Column(children: [
                      Row(children: [
                        Icon(
                          Icons.auto_awesome,
                          color: ThemeColors.primary,
                          size: 22.w,
                        ),
                        // Image.asset('images/icon_sparkel.png'),
                        SizedBox(
                          width: 5.w,
                        ),
                        TextCustom(
                          text: '지금 인기있는 정책은?',
                          color: Colors.black, //ThemeColors.basic,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ]),
                      SizedBox(
                        height: 15.h,
                      ),
                      // 실시간 인기글
                      FutureBuilder<List<Policy>>(
                          future: policyService.getAllPolicy('2'), // 스크랩 수 많은 순
                          builder: ((_, snapshot) {
                            if (snapshot.data != null &&
                                snapshot.data!.isEmpty) {
                              return _ListWithoutPopularPolicy();
                            }
                            if (!snapshot.hasData) {
                              return _ListWithoutPopularPolicy(); //const _ShimerLoadingPopularPolicy();
                            } else {
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length > 5
                                      ? 5
                                      : snapshot.data!.length,
                                  itemBuilder: (_, i) => livePopularPolicy(
                                      // codeData: codeData,
                                      ranking: i,
                                      policies: snapshot.data![i]));
                            }
                          })),
                    ])),
                  ),

                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const BottomNavigation(index: 1)),
    );
  }
}

// 배너 슬라이드
class BannerSlide extends StatelessWidget {
  final Banners policyBanners;
  const BannerSlide({super.key, required this.policyBanners});

  @override
  Widget build(BuildContext context) {
    final bannerImgName = policyBanners.banner_img;
    final bannerImgUrl =
        '${Environment.urlApiServer}/upload/banner/$bannerImgName';
    final bannerLink = policyBanners.banner_link;
    final url = Uri.parse(bannerLink);

    return InkWell(
      onTap: () {
        launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
        // launchUrl(Uri.parse(bannerLink));
      },
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            bannerImgUrl,
            fit: BoxFit.fitWidth,
          )),
    );
  }
}

// 등록된 배너 없을 때
class _ListWithoutBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset('images/default_banner.png'));

    // Container(
    //     height: 150.h,
    //     decoration: BoxDecoration(
    //       // color: Colors.grey[200],
    //       borderRadius: BorderRadius.circular(20),
    //       // boxShadow: [
    //       //   BoxShadow(
    //       //     color: Colors.grey.withOpacity(0.5),
    //       //     spreadRadius: 1.r,
    //       //     blurRadius: 5.r,
    //       //     offset: const Offset(0, 3),
    //       //   ),
    //       // ],
    //     ),
    //     padding: const EdgeInsets.all(15).w,
    //     // margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
    //     child: Container());
  }
}

class HomeCategory {
  final String title;
  final String code;
  final String codeName;
  final String codeDetailName;
  final String icon;
  HomeCategory(
      {required this.title,
      required this.code,
      required this.codeName,
      required this.codeDetailName,
      required this.icon});
}

// 카테고리 아이콘 버튼
class CategoryButton extends StatefulWidget {
  const CategoryButton({super.key});

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  List<CodeDetailData> codeDetailDataList = [];
  static String codeName = "policy_field_code";
  @override
  void initState() {
    super.initState();
    codeDetailDataList = getMobileCodeService.getCodeDetailList(codeName);
  }

  @override
  Widget build(BuildContext context) {
    // codeDetailDataList.forEach((element) {
    //   print(element.detailName);
    // });

    final List<HomeCategory> categoryIcons01 = codeDetailDataList
        .where((detail) => ['00', '01', '02', '03'].contains(detail.code))
        .map((detail) => HomeCategory(
            title: [
              '학업',
              '상담',
              '취업/이직',
              '생활비'
            ][['00', '01', '02', '03'].indexOf(detail.code)],
            code: detail.code,
            codeName: codeName,
            codeDetailName: detail.detailName,
            icon: 'images/category_icon/icon_${detail.code}.svg'))
        .toList();

    final List<HomeCategory> categoryIcons02 = codeDetailDataList
        .where((detail) => ['04', '05', '06'].contains(detail.code))
        .map((detail) => HomeCategory(
            title: ['건강', '주거', '결혼/양육'][[
              '04',
              '05',
              '06',
            ].indexOf(detail.code)],
            code: detail.code,
            codeName: codeName,
            codeDetailName: detail.detailName,
            icon: 'images/category_icon/icon_${detail.code}.svg'))
        .toList();

    // 전체보기 HomeCategory 추가
    categoryIcons02.add(HomeCategory(
        title: '전체보기',
        code: '',
        codeName: codeName,
        codeDetailName: '', // 비어 있는 문자열로 초기화
        icon: 'images/category_icon/icon_total.svg'));

    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (index) => Container(
                margin: const EdgeInsets.only(bottom: 5.0).w,
                padding: const EdgeInsets.all(10.0).w,
                child: Column(children: [
                  IconButton(
                      icon: SvgPicture.asset(
                          categoryIcons01[index].icon), //pngIcons01[index]
                      onPressed: () {
                        var codeName = categoryIcons01[index].codeName;
                        var codeValue = categoryIcons01[index].code;
                        var codeDetailName =
                            categoryIcons01[index].codeDetailName;
                        // print(codeDetailName + codeValue + codeName);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PolicyListPage(
                                      selectedCodes: SelectedCodes(
                                    policyInstitution: [],
                                    policyTarget: [],
                                    policyField: [
                                      CodeDetailData(
                                          code: codeValue,
                                          codeName: codeName,
                                          detailName: codeDetailName)
                                    ],
                                    policyCharacter: [],
                                    // policyArea: []
                                  ))),
                        );
                      },
                      iconSize: 32.w), //MediaQuery.of(context).size.width / 8),
                  TextCustom(
                    text: categoryIcons01[index].title,
                    fontSize: 13.sp,
                    color: ThemeColors.basic,
                    // fontWeight: FontWeight.w600,
                  ),
                ]),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (index) => Container(
                margin: const EdgeInsets.only(bottom: 5.0).w,
                padding: const EdgeInsets.all(10.0).w,
                child: Column(children: [
                  IconButton(
                    icon: SvgPicture.asset(categoryIcons02[index].icon),
                    onPressed: () {
                      var codeName = categoryIcons02[index].codeName;
                      var codeValue = categoryIcons02[index].code;
                      var codeDetailName =
                          categoryIcons02[index].codeDetailName;
                      // print(codeDetailName + codeValue + codeName);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PolicyListPage(
                                    selectedCodes: SelectedCodes(
                                  policyInstitution: [],
                                  policyTarget: [],
                                  policyField: [
                                    CodeDetailData(
                                        code: codeValue,
                                        codeName: codeName,
                                        detailName: codeDetailName)
                                  ],
                                  policyCharacter: [],
                                  // policyArea: []
                                ))),
                      );
                    },
                    iconSize: 32.w, //MediaQuery.of(context).size.width / 8,
                  ),
                  TextCustom(
                    text: categoryIcons02[index].title,
                    fontSize: 13.sp,
                    color: ThemeColors.basic,
                    // fontWeight: FontWeight.w600,
                  ),
                ]),
                // height: 40,
                // width: size.width / 4,
                // constraints: const BoxConstraints(maxWidth: 100),
                // color: Colors.amber,
              ),
            ),
          ),
        ]);
  }
}

// 실시간 인기 글
class livePopularPolicy extends StatelessWidget {
  final Policy policies;
  final int ranking;
  // final Map<String, dynamic> codeData;

  const livePopularPolicy({
    super.key,
    required this.policies,
    required this.ranking,
    // required this.codeData
  });

  @override
  Widget build(BuildContext context) {
    final iconList = [
      Icons.looks_one_outlined,
      Icons.looks_two_outlined,
      Icons.looks_3_outlined,
      Icons.looks_4_outlined,
      Icons.looks_5_outlined,
    ];

    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0).w,
        margin: const EdgeInsets.fromLTRB(0, 1, 0, 1).w,
        child: ListTile(
            minLeadingWidth: 0,
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 20, 0).w,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPolicyPage(policies),
                  ));
            },
            leading: Icon(
              iconList[ranking],
              //Icons.looks_one,
              color: ThemeColors.primary,
            ),
            title: TextCustom(
              text: policies.policy_name,
              color: ThemeColors.basic,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            )));
  }
}

class _ListWithoutPopularPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20).w,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/aco4.png',
                width: 100.w,
                height: 90.w,
              ),
              SizedBox(
                height: 20.h,
              ),
              TextCustom(text: '등록된 정책이 없어요', fontSize: 20.sp),
            ],
          ),
        ));
  }
}

class _ShimerLoadingPopularPolicy extends StatelessWidget {
  const _ShimerLoadingPopularPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShimmerNaru(),
        SizedBox(height: 5.0.h),
        const ShimmerNaru(),
        SizedBox(height: 5.0.h),
        const ShimmerNaru(),
      ],
    );
  }
}
