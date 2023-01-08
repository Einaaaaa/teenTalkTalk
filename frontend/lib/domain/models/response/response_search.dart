import 'dart:convert';

ResponseSearch responseSearchFromJson(String str) =>
    ResponseSearch.fromJson(json.decode(str));

String responseSearchToJson(ResponseSearch data) => json.encode(data.toJson());

class ResponseSearch {
  ResponseSearch({
    required this.resp,
    required this.message,
    required this.userFind,
  });

  bool resp;
  String message;
  List<UserFind> userFind;

  factory ResponseSearch.fromJson(Map<String, dynamic> json) => ResponseSearch(
        resp: json["resp"],
        message: json["message"],
        userFind: List<UserFind>.from(
            json["userFind"].map((x) => UserFind.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resp": resp,
        "message": message,
        "userFind": List<dynamic>.from(userFind.map((x) => x.toJson())),
      };
}

class UserFind {
  UserFind({
    required this.user_id,
    required this.user_name,
    required this.user_email,
    // required this.phone_no,
  });

  String user_id;
  String user_name;
  String user_email;
  // String phone_no;

  factory UserFind.fromJson(Map<String, dynamic> json) => UserFind(
        user_id: json["user_id"],
        user_name: json["user_name"],
        user_email: json["user_email"],
        // phone_no: json["phone_no"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": user_id,
        "user_name": user_name,
        "user_email": user_email,
        // "phone_no": phone_no,
      };
}
