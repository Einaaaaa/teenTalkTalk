import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:teentalktalk/data/storage/secure_storage.dart';
import 'package:teentalktalk/domain/models/response/default_response.dart';
import 'package:teentalktalk/domain/models/response/response_user_fig_count.dart';
import 'package:teentalktalk/domain/models/response/response_event.dart';
import 'package:teentalktalk/domain/models/response/response_fig_history.dart';
import 'package:teentalktalk/data/env/env.dart';

class EventServices {
  // 무화과 지급 - 출석 체크
  Future<DefaultResponse> giveFigForAttendance() async {
    final token = await secureStorage.readToken();

    final resp = await http.post(
        Uri.parse('${Environment.urlApi}/event/give-fig-for-attendance'),
        headers: {'Accept': 'application/json', 'xxx-token': token!},
        body: {});
    // print(resp.body);
    return DefaultResponse.fromJson(jsonDecode(resp.body));
  }

  // 무화과 지급 - 친구 초대
  Future<DefaultResponse> giveFigForInvitation(String invite_code) async {
    final token = await secureStorage.readToken();

    final resp = await http.post(
        Uri.parse('${Environment.urlApi}/event/give-fig-for-invitation'),
        headers: {'Accept': 'application/json', 'xxx-token': token!},
        body: {'invite_code': invite_code});
    // print(resp.body);
    return DefaultResponse.fromJson(jsonDecode(resp.body));
  }

  // 무화과 지급 - 주간 무화과 챌린지
  // give-fig-for-weekly
  Future<DefaultResponse> giveFigForWeeklyFigChallenge(String eid) async {
    final token = await secureStorage.readToken();

    final resp = await http.post(
        Uri.parse('${Environment.urlApi}/event/give-fig-for-weekly'),
        headers: {'Accept': 'application/json', 'xxx-token': token!},
        body: {'eid': eid});
    // print(resp.body);
    return DefaultResponse.fromJson(jsonDecode(resp.body));
  }

  // 가입 24시간 이내 확인
  Future<DefaultResponse> checkUserWithin24Hours() async {
    final token = await secureStorage.readToken();

    final resp = await http.get(
        Uri.parse('${Environment.urlApi}/event/check-user-within-24h'),
        headers: {'Accept': 'application/json', 'xxx-token': token!});
    // print('checkUserWithin24Hours');
    // print(resp.body);

    return DefaultResponse.fromJson(jsonDecode(resp.body));
  }

  // 이벤트 내역 확인
  Future<DefaultResponse> checkEventParticipation(String eid) async {
    final token = await secureStorage.readToken();

    final resp = await http.get(
        Uri.parse(
            '${Environment.urlApi}/event/check-event-participation-available/$eid'),
        headers: {'Accept': 'application/json', 'xxx-token': token!});
    // print('checkEventParticipation');
    print(resp.body);

    return DefaultResponse.fromJson(jsonDecode(resp.body));
  }

  // 출석체크 기록 가져오기
  Future<List<DateTime>> getAttendance() async {
    final token = await secureStorage.readToken();

    final resp = await http.get(
        Uri.parse('${Environment.urlApi}/event/get-attendance'),
        headers: {'Accept': 'application/json', 'xxx-token': token!});

    final decodedJson = jsonDecode(resp.body);
    final attendanceLogJson = decodedJson['attendaceLog'] as List<dynamic>;
    final List<DateTime> attendanceLog = attendanceLogJson
        .map((log) => DateTime.parse(log['attendance_date'].toString()))
        .toList();
    // print(attendanceLog);
    return attendanceLog;
  }

  // 사용자 무화과 내역 가져오기(지급, 사용)
  Future<ResponseFigHistory> getFigHistoryByUser() async {
    final token = await secureStorage.readToken();

    // print('getFigHistoryByUser');
    final resp = await http.get(
        Uri.parse('${Environment.urlApi}/event/get-fig-history-by-user'),
        headers: {'Accept': 'application/json', 'xxx-token': token!});
    // print(resp.body);

    return ResponseFigHistory.fromJson(jsonDecode(resp.body));
  }

  // 이벤트 참여여부
  Future<DefaultResponse> submitFigEventParticipation() async {
    final token = await secureStorage.readToken();

    final resp = await http.get(
        Uri.parse('${Environment.urlApi}/event//participate-event'),
        headers: {'Accept': 'application/json', 'xxx-token': token!});
    // print('submitFigEventParticipation');
    print(resp.body);

    return DefaultResponse.fromJson(jsonDecode(resp.body));
  }
}

final eventService = EventServices();
