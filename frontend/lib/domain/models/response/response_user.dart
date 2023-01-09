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
  String userID;
  String userName;
  String userEmail;
  String userPW;
  String tokenTemp;
  bool emailVerified;
  // String phone_no;

  User({
    required this.userID,
    required this.userName,
    required this.userEmail,
    required this.userPW,
    required this.tokenTemp,
    required this.emailVerified,
    // required this.phone_no,
  });

  // factory User.fromJson(Map<String, dynamic> json) => User(
  //       userID: json["user_id"] ?? '',
  //       userName: json["user_name"] ?? '',
  //       userEmail: json["user_email"] ?? '',
  //       userPW: json["user_pw"] ?? '',
  //       tokenTemp: json["token_temp"] ?? '',
  //       emailVerified: json["email_verified"] ?? -0,
  //       // phone_no: json["phone_no"] ?? '',
  //     );

  factory User.fromJson(Map<String, dynamic> json) => User(
        userID: json["user_id"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        userPW: json["user_pw"],
        tokenTemp: json["token_temp"],
        emailVerified: json["email_verified"],
        // phone_no: json["phone_no"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "user_id": userID,
        "user_name": userName,
        "user_email": userEmail,
        "user_pw": userPW,
        "token_temp": tokenTemp,
        "email_verified": emailVerified,
        // "phone_no" : phone_no,
      };
}
