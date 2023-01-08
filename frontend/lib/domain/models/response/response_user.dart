import 'dart:convert';

ResponseUser responseUserFromJson(String str) =>
    ResponseUser.fromJson(json.decode(str));

String responseUserToJson(ResponseUser data) => json.encode(data.toJson());

class ResponseUser {
  bool resp;
  String message;
  User user;
  // PostsUser postsUser;

  ResponseUser({
    required this.resp,
    required this.message,
    required this.user,
    // required this.postsUser,
  });

  factory ResponseUser.fromJson(Map<String, dynamic> json) => ResponseUser(
        resp: json["resp"],
        message: json["message"],
        user: User.fromJson(json["user"]),
        // postsUser: PostsUser.fromJson(json["posts"]),
      );

  Map<String, dynamic> toJson() => {
        "resp": resp,
        "message": message,
        "user": user.toJson(),
        // "posts": postsUser.toJson(),
      };
}

// class PostsUser {
//
//   int posters;
//   int friends;
//   int followers;
//
//   PostsUser({
//     required this.posters,
//     required this.friends,
//     required this.followers,
//   });
//
//   factory PostsUser.fromJson(Map<String, dynamic> json) => PostsUser(
//     posters: json["posters"] ?? -0,
//     friends: json["friends"] ?? -0,
//     followers: json["followers"] ?? -0,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "posters": posters,
//     "friends": friends,
//     "followers": followers,
//   };
// }

class User {
  String user_id;
  String user_name;
  String user_email;
  String user_pw;
  // String phone_no;

  User({
    required this.user_id,
    required this.user_name,
    required this.user_email,
    required this.user_pw,
    // required this.phone_no,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        user_id: json["user_id"] ?? '',
        user_name: json["user_name"] ?? '',
        user_email: json["user_email"] ?? '',
        user_pw: json["user_pw"] ?? '',
        // phone_no: json["phone_no"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "user_id": user_id,
        "user_name": user_name,
        "user_email": user_email,
        "user_pw": user_pw,
        // "phone_no" : phone_no,
      };
}
