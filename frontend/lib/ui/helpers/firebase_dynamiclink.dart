import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<String> buildPolicyDynamicLink(String policyId) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix:
        "https://teentalktalk.page.link", // Firebase Dynamic Links 도메인 주소
    link: Uri.parse(
        'https://teentalktalk.page.link/policy?policyId=$policyId'), // 정책 ID를 링크에 추가
    androidParameters: const AndroidParameters(
      packageName: "com.naru.teenTalkTalk", // 안드로이드 앱 패키지 이름
    ),
    // iosParameters: IosParameters(
    //   bundleId: "com.example.teenTalkTalk", // iOS 앱의 번들 ID
    // ),
  );
  final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(parameters);
  print('buildDynamicLink : $dynamicLink');
  return dynamicLink.toString();

  // final ShortDynamicLink dynamicLink =
  //     await FirebaseDynamicLinks.instance.buildShortLink(parameters);
  // final String shortURL = dynamicLink.shortUrl.toString();
  // print('buildDynamicLink : $shortURL');
  // return shortURL;
}

Future<String> buildInvitationDynamicLink(String invite_code) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix:
        "https://teentalktalk.page.link", // Firebase Dynamic Links 도메인 주소
    link: Uri.parse(
        'https://teentalktalk.page.link/invitation?code=$invite_code'), // 추천인 코드를 링크에 추가
    androidParameters: const AndroidParameters(
      packageName: "com.naru.teenTalkTalk", // 안드로이드 앱 패키지 이름
    ),
    // iosParameters: IosParameters(
    //   bundleId: "com.example.teenTalkTalk", // iOS 앱의 번들 ID
    // ),
  );
  final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(parameters);
  print('buildDynamicLink : $dynamicLink');
  return dynamicLink.toString();

  // final ShortDynamicLink dynamicLink =
  //     await FirebaseDynamicLinks.instance.buildShortLink(parameters);
  // final String shortURL = dynamicLink.shortUrl.toString();
  // print('buildDynamicLink : $shortURL');
  // return shortURL;
}
