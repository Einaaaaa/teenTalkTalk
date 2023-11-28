import 'dart:convert';

DefaultResponse defaultResponseFromJson(String str) =>
    DefaultResponse.fromJson(json.decode(str));

String defaultResponseToJson(DefaultResponse data) =>
    json.encode(data.toJson());

class DefaultResponse {
  bool resp;
  String message;
  int? partCount; // 이벤트 참여 내역 횟수 - 친구초대 사용
  String? link; // 만족도 조사 링크

  DefaultResponse({
    required this.resp,
    required this.message,
    this.partCount,
    this.link,
  });

  factory DefaultResponse.fromJson(Map<String, dynamic> json) =>
      DefaultResponse(
          resp: json["resp"],
          message: json["message"],
          partCount: json["partCount"],
          link: json["link"]);

  Map<String, dynamic> toJson() =>
      {"resp": resp, "message": message, "partCount": partCount, "link": link};
}
