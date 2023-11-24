import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:flutter_share/flutter_share.dart';
import 'package:teentalktalk/data/env/env.dart';
import 'package:teentalktalk/domain/blocs/auth/auth_bloc.dart';
import 'package:teentalktalk/domain/models/response/response_policy.dart';
import 'package:teentalktalk/domain/services/event_services.dart';
import 'package:teentalktalk/domain/services/policy_services.dart';
import 'package:teentalktalk/ui/helpers/firebase_dynamiclink.dart';
import 'package:teentalktalk/ui/helpers/get_mobile_code_data.dart';
import 'package:teentalktalk/ui/helpers/kakao_sdk_share.dart';
import 'package:teentalktalk/ui/helpers/modals/modal_getFig.dart';
import 'package:teentalktalk/ui/themes/theme_colors.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:teentalktalk/ui/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPolicyPage extends StatefulWidget {
  const DetailPolicyPage(
    this.policies, {
    Key? key,
  }) : super(key: key);
  final Policy policies;

  // final Map<String, dynamic> codeData;
  // final Future< dynamic> codeData;

  @override
  State<DetailPolicyPage> createState() => _DetailPolicyState();
}

class _DetailPolicyState extends State<DetailPolicyPage> {
  late bool hasEventParticipated = false;

  @override
  void initState() {
    super.initState();
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is SuccessAuthentication) {
      checkEventParticipation();
    }
  }

  Future<void> checkEventParticipation() async {
    // true -> 참여 기록 없음. 참여 가능
    // false -> 참여 기록 있음. 참여 불가능
    var resp = await eventService.checkEventParticipation('4');
    setState(() {
      hasEventParticipated = resp.resp;
    });
    // print(hasEventParticipated);
  }

  Future<void> _shareURL(String policyName, String img, String policyId) async {
    String dynamicLink = await buildPolicyDynamicLink(policyId);
    try {
      await FlutterShare.share(
        title: policyName,
        text: 'URL 복사하기',
        linkUrl: dynamicLink,
        // chooserTitle: 'Example Chooser Title',
      );
    } catch (e) {
      print('Error sharing : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Policy policies = widget.policies;
    // final Map<String, dynamic> codeData = widget.codeData;

    // 기관
    final String policyInstitution = getMobileCodeService.getCodeDetailName(
        'policy_institution_code', policies.policy_institution_code);

    // 모집대상
    final String policyTarget = getMobileCodeService.getCodeDetailName(
        'policy_target_code', policies.policy_target_code);
    // 정책 분야
    final String policyField = getMobileCodeService.getCodeDetailName(
        'policy_field_code', policies.policy_field_code);
    // 정책 성격
    final String policyCharacter = getMobileCodeService.getCodeDetailName(
        'policy_character_code', policies.policy_character_code);
    // 이미지
    final String imgName = policies.img;
    final String imgUrl = '${Environment.urlApiServer}/upload/policy/$imgName';

    final String policyId = policies.pid;
    final String policyName = policies.policy_name;
    final String policyContent = policies.content;
    final String policyLink = policies.policy_link;

    //모집기간
    final String startDateYear =
        policies.application_start_date.substring(0, 4);
    final String endDateYear = policies.application_end_date.substring(0, 4);
    final String startDateMonth =
        policies.application_start_date.substring(5, 7);
    final String endDateMonth = policies.application_end_date.substring(5, 7);
    final String startDateDay =
        policies.application_start_date.substring(8, 10);
    final String endDateDay = policies.application_end_date.substring(8, 10);
    final String startDate = '$startDateYear.$startDateMonth.$startDateDay';
    final String endDate = '$endDateYear.$endDateMonth.$endDateDay';

    final size = MediaQuery.of(context).size.width;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: ThemeColors.primary,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.share,
                    color: ThemeColors.primary,
                  ),
                  padding: const EdgeInsets.only(right: 20),
                  onPressed: () async {
                    if (hasEventParticipated) {
                      eventService.giveFigForWeeklyFigChallenge('4');
                      modalGetFig(context, '4');
                    }
                    // _shareURL(policyName, imgUrl, policyId);
                    policyService.getPolicyById(policyId);
                    String dynamicLink = await buildPolicyDynamicLink(policyId);
                    KakaoShareServices.kakaoSharePolicy(
                        policyName, imgUrl, dynamicLink);
                  },
                ),
              ]),
          body: SafeArea(
              child: SingleChildScrollView(
                  child: Center(
                      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: size,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(children: [
                  SizedBox(
                    width: size / 1.5,
                    child: Image.network(
                      imgUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                ]),
              ),
              Container(
                  // 주최측
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 5),
                  width: size,
                  color: Colors.white,
                  child: TextCustom(
                    text: policyInstitution,
                    fontSize: 15,
                  )),
              Container(
                // 정책 이름
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                width: size,
                color: Colors.white,
                child: TextCustom(
                    text: policyName,
                    color: Colors.black,
                    maxLines: 2,
                    fontSize: 25,
                    fontWeight: FontWeight.w800),
              ),
              Container(
                // 카테고리
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                width: size,
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ThemeColors.secondary,
                      ),
                      child: TextCustom(
                        text: policyField,
                        // policyCategory,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ThemeColors.secondary,
                      ),
                      child: TextCustom(
                        text: policyCharacter,
                        // policyCategory,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  // 모집대상
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                  width: size,
                  color: Colors.white,
                  child: Row(
                    children: [
                      const TextCustom(
                        text: '모집대상',
                        color: ThemeColors.basic,
                        // fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      SizedBox(
                        width: size / 20,
                      ),
                      TextCustom(
                        text: policyTarget,
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  )),
              Container(
                  // 모집기간
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                  width: size,
                  color: Colors.white,
                  child: Row(
                    children: [
                      const TextCustom(
                        text: '모집기간',
                        color: ThemeColors.basic,
                        // fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      SizedBox(
                        width: size / 20,
                      ),
                      TextCustom(
                        text: '$startDate ~ $endDate', //'관내 초등학생',
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  )),
              const Divider(
                height: 20,
                thickness: 2,
              ),
              Container(
                // 상세내용
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                width: size,
                color: Colors.white,
                child: Html(
                  data: policyContent,
                  style: {
                    'p': Style(
                        color: Colors.black,
                        fontFamily: 'NanumSquareRound',
                        fontSize: FontSize.large,
                        lineHeight: LineHeight.percent(120)),
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                margin: const EdgeInsets.only(bottom: 20),
                width: size,
                color: Colors.white,
                child: BtnNaru(
                  text: '신청하기',
                  colorText: Colors.white,
                  fontWeight: FontWeight.bold,
                  width: size,
                  onPressed: () {
                    launchUrl(
                      Uri.parse(policyLink),
                      mode: LaunchMode.externalApplication,
                    );
                    // launchUrl(Uri.parse(policyLink));
                  },
                ),
              )
            ],
          )))),
        ));
  }
}
