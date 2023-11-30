import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:teentalktalk/domain/services/event_services.dart';

class KakaoShareService {
  // 정책 공유 이벤트 참여 여부
  // true -> 무화과 지급 X
  // false -> 무화과 지급 O
  // late bool hasParticipatedSharePolicy = true;

  // Future<void> checkEventParticipation() async {
  //   // true -> 참여 기록 없음. 참여 가능
  //   // false -> 참여 기록 있음. 참여 불가능
  //   var resp = await eventService.checkEventParticipation('5');
  //   setState(() {
  //     hasParticipatedSharePolicy = !resp.resp;
  //   });
  // }

  // 정책 공유 템플릿
  FeedTemplate sharePolicyTemplate(
      String policyName, String policyImgLink, String link) {
    // print(policyImgLink);
    print('getSharePolicyTemplate $link');
    Content content = Content(
        title: policyName,
        imageUrl: Uri.parse(policyImgLink),
        link: Link(webUrl: Uri.parse(link), mobileWebUrl: Uri.parse(link)));
    FeedTemplate template = FeedTemplate(content: content, buttons: [
      Button(
          title: "자세히 보기",
          link: Link(webUrl: Uri.parse(link), mobileWebUrl: Uri.parse(link)))
    ]);

    return template;
  }

  Future<void> kakaoSharePolicy(
      String policyName, String policyImgLink, String link) async {
    // 카카오톡 실행 가능 여부 확인
    bool isKakaoTalkSharingAvailable =
        await ShareClient.instance.isKakaoTalkSharingAvailable();

    if (isKakaoTalkSharingAvailable) {
      var template = sharePolicyTemplate(policyName, policyImgLink, link);
      try {
        Uri uri = await ShareClient.instance.shareDefault(template: template);
        await ShareClient.instance.launchKakaoTalk(uri);
        // Uri shareUrl =
        //     await WebSharerClient.instance.makeDefaultUrl(template: template);
        // await launchBrowserTab(shareUrl, popupOpen: true);
        print('카카오톡 공유 완료');

        //  if(!hasParticipatedSharePolicy){
        //    eventService.giveFigForWeeklyFigChallenge('5');
        //  }
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
    } else {
      try {} catch (error) {
        print('카카오톡 공유 실패 $error');
      }
    }
  }

  // // 카카오톡 친구초대 메시지 템플릿
  // FeedTemplate inviteFriendsTemplate(String invite_code, String link) {
  //   // print(policyImgLink);
  //   Content content = Content(
  //       title: '💌청소년 톡talk 초대장 도착💌',
  //       description: '초대코드 : $invite_code 입력하고 무화과 포인트를 받아보세요!',
  //       imageUrl: Uri.parse('images/invitation_event.png'),
  //       link: Link(webUrl: Uri.parse(link), mobileWebUrl: Uri.parse(link)));
  //   FeedTemplate template = FeedTemplate(content: content, buttons: [
  //     Button(
  //         title: "초대 수락하기",
  //         link: Link(webUrl: Uri.parse(link), mobileWebUrl: Uri.parse(link)))
  //   ]
  //   );

  //   return template;
  // }

  // 카카오톡 친구초대 메시지 템플릿
  FeedTemplate inviteFriendsTemplate(String invite_code, String link) {
    // print(policyImgLink);
    Content content = Content(
      title: '💌청소년 톡talk 초대장 도착💌',
      description: '초대코드 : $invite_code 입력하고 무화과 포인트를 받아보세요!',
      imageUrl: Uri.parse('images/invitation_event.png'),
      link: Link(webUrl: Uri.parse(link), mobileWebUrl: Uri.parse(link)),
    );

    // Omit the buttons parameter to remove the button
    FeedTemplate template = FeedTemplate(content: content);

    return template;
  }

  // 카카오톡 친구 초대
  Future<void> kakaoInviteFreinds(String invite_code, String link) async {
    print(invite_code);
    // // 사용자 정의 템플릿 ID
    // int templateId = 94735;
    // 카카오톡 실행 가능 여부 확인
    bool isKakaoTalkSharingAvailable =
        await ShareClient.instance.isKakaoTalkSharingAvailable();

    if (isKakaoTalkSharingAvailable) {
      var template = inviteFriendsTemplate(invite_code, link);
      try {
        Uri uri = await ShareClient.instance.shareDefault(template: template);
        await ShareClient.instance.launchKakaoTalk(uri);
        print('카카오톡 공유 완료');
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
    } else {
      try {
        // Uri shareUrl = await WebSharerClient.instance.makeCustomUrl(
        //     templateId: templateId, templateArgs: {'key1': 'value1'});
        // await launchBrowserTab(shareUrl, popupOpen: true);
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
    }
  }
}

final KakaoShareServices = KakaoShareService();
