part of 'user_bloc.dart';

@immutable
class UserState {
  final User? user;
  // final PostsUser? postsUser;
  // final bool isPhotos;

  const UserState({
    this.user,
    // this.isPhotos = true,
    // this.postsUser
  });

  UserState copyWith({User? user}) => UserState(
        user: user ?? this.user,
        // isPhotos: isPhotos ?? this.isPhotos,
        // postsUser: postsUser ?? this.postsUser
      );
}

class LoadingUserState extends UserState {}

class LoadingEditUserState extends UserState {}

class SuccessUserState extends UserState {}

class SuccessKakaoUserState extends UserState {}

class FailureUserState extends UserState {
  final String error;

  const FailureUserState(this.error);
}

class LoadingChangeAccount extends UserState {}
