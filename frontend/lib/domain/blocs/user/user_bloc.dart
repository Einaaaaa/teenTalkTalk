// ignore_for_file: depend_on_referenced_packages

// import 'dart:html';
// import 'dart:js';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
import 'package:login/domain/models/response/response_user.dart';
import 'package:login/domain/services/user_services.dart';

// import 'package:login/ui/popup/register/register_success.dart';
import '../../../ui/helpers/animation_route.dart';
import '../../../ui/screens/login/login_page.dart';
// import '../../../ui/themes/theme_colors.dart';
// import '../../../ui/widgets/widgets.dart';
// import '../../services/user_services.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    on<OnGetUserAuthenticationEvent>(_onGetUserAuthentication);
    on<OnRegisterUserEvent>(_onRegisterUser);
    on<OnVerifyEmailEvent>(_onVerifyEmail);
    // on<OnUpdatePictureCover>( _onUpdatePictureCover );
    // on<OnUpdatePictureProfile>( _onUpdatePictureProfile );
    // on<OnUpdateProfileEvent>( _onUpdateProfile );
    on<OnChangePasswordEvent>(_changePassword);
    // on<OnToggleButtonProfile>( _toggleButtonProfile );
    // on<OnChangeAccountToPrivacy>( _changeAccountPrivacy );
    on<OnLogOutUser>(_logOutAuth);
    // on<OnAddNewFollowingEvent>( _addNewFollowing );
    // on<OnAcceptFollowerRequestEvent>( _acceptFollowerRequest );
    // on<OnDeletefollowingEvent>( _deleteFollowing );
    // on<OnDeletefollowersEvent>( _deleteFollowers );
  }

  Future<void> _onGetUserAuthentication(
      OnGetUserAuthenticationEvent event, Emitter<UserState> emit) async {
    try {
      final data = await userService.getUserById();

      emit(state.copyWith(user: data.user));
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> _onRegisterUser(
      OnRegisterUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());

      await Future.delayed(const Duration(milliseconds: 550));
      print("_onRegisterUser");
      final resp = await userService.createdUser(
          event.user_id,
          event.user_name,
          event.user_email,
          event.user_pw,
          event.user_pw2,
          event.user_role,
          event.user_type,
          event.youthAge_code,
          event.parentsAge_code,
          event.emd_class_code,
          event.sex_class_code);
      print(event);
      print(resp.resp);
      print(resp.message);

      if (resp.resp) {
        emit(SuccessUserState());
      } else {
        emit(FailureUserState(resp.message));
      }
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> _onVerifyEmail(
      OnVerifyEmailEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());
      print("_onVerifyEmail");

      final resp = await userService.verifyEmail(event.user_email, event.code);

      await Future.delayed(const Duration(milliseconds: 350));

      if (resp.resp) {
        emit(SuccessUserState());
      } else {
        emit(FailureUserState(resp.message));
      }
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }

  // Future<void> _onUpdatePictureCover( OnUpdatePictureCover event, Emitter<UserState> emit ) async {
  //
  //   try {
  //
  //     emit( LoadingUserState() );
  //
  //     final data = await userService.updatePictureCover(event.pathCover);
  //
  //     await Future.delayed(const Duration(milliseconds: 450));
  //
  //     if( data.resp ){
  //
  //       final dataUser = await userService.getUserById();
  //
  //       emit(SuccessUserState());
  //
  //       // emit( state.copyWith(user: dataUser.user, postsUser: dataUser.postsUser));
  //
  //     }else{
  //       emit( FailureUserState( data.message ));
  //     }
  //
  //   } catch (e) {
  //     emit( FailureUserState(e.toString()) );
  //   }
  //
  // }

  // Future<void> _onUpdatePictureProfile( OnUpdatePictureProfile event, Emitter<UserState> emit ) async {
  //
  //   try {
  //
  //     emit( LoadingUserState() );
  //
  //     final data = await userService.updatePictureProfile( event.pathProfile );
  //
  //     await Future.delayed(const Duration(milliseconds: 450));
  //
  //     if( data.resp ){
  //
  //       final dataUser = await userService.getUserById();
  //
  //       emit( SuccessUserState() );
  //
  //       emit( state.copyWith(user: dataUser.user, postsUser: dataUser.postsUser));
  //
  //     }else{
  //       emit( FailureUserState(data.message) );
  //     }
  //
  //   } catch (e) {
  //     emit( FailureUserState(e.toString()) );
  //   }
  //
  // }
  //
  //
  // Future<void> _onUpdateProfile( OnUpdateProfileEvent event, Emitter<UserState> emit ) async {
  //
  //   try {
  //
  //     emit( LoadingEditUserState() );
  //
  //     final data = await userService.updateProfile(event.user, event.description, event.fullname, event.phone);
  //
  //     if( data.resp ){
  //
  //       final dataUser = await userService.getUserById();
  //
  //       emit( SuccessUserState() );
  //
  //       emit( state.copyWith(user: dataUser.user, postsUser: dataUser.postsUser));
  //
  //     }else {
  //       emit( FailureUserState(data.message) );
  //     }
  //
  //   } catch (e) {
  //     emit( FailureUserState(e.toString()) );
  //   }
  // }

  Future<void> _changePassword(
      OnChangePasswordEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingUserState());

      final data = await userService.changePassword(
          event.currentPassword, event.newPassword);

      await Future.delayed(const Duration(milliseconds: 450));

      final dataUser = await userService.getUserById();

      if (data.resp) {
        emit(SuccessUserState());

        // emit( state.copyWith(user: dataUser.user, postsUser: dataUser.postsUser));

      } else {
        emit(FailureUserState(data.message));

        // emit( state.copyWith(user: dataUser.user, postsUser: dataUser.postsUser));

      }
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }

  // Future<void> _toggleButtonProfile( OnToggleButtonProfile event, Emitter<UserState> emit ) async {
  //
  //   emit( state.copyWith( isPhotos:  event.isPhotos));
  //
  // }

  // Future<void> _changeAccountPrivacy( OnChangeAccountToPrivacy event, Emitter<UserState> emit ) async {
  //
  //   try {
  //
  //     emit( LoadingChangeAccount() );
  //
  //     final data = await userService.changeAccountPrivacy();
  //
  //     await Future.delayed(const Duration(milliseconds: 350));
  //
  //     if( data.resp ){
  //
  //       final data = await userService.getUserById();
  //
  //       emit( SuccessUserState() );
  //
  //       // emit( state.copyWith(user: data.user, postsUser: data.postsUser));
  //
  //     }else {
  //       FailureUserState(data.message);
  //     }
  //
  //   } catch (e) {
  //     emit(FailureUserState(e.toString()));
  //   }
  //
  // }

  Future<void> _logOutAuth(OnLogOutUser event, Emitter<UserState> emit) async {
    emit(state.copyWith(user: null));
  }

  // Future<void> _addNewFollowing(OnAddNewFollowingEvent event, Emitter<UserState> emit) async {
  //
  //   try {
  //
  //     emit(LoadingFollowingUser());
  //
  //     final data = await userService.addNewFollowing(event.uidFriend);
  //
  //     if(data.resp){
  //
  //       final data = await userService.getUserById();
  //
  //       emit( SuccessFollowingUser() );
  //
  //       emit( state.copyWith(user: data.user, postsUser: data.postsUser));
  //
  //     }else {
  //       FailureUserState(data.message);
  //     }
  //
  //   } catch (e) {
  //     emit(FailureUserState(e.toString()));
  //   }
  //
  // }

  // Future<void> _acceptFollowerRequest( OnAcceptFollowerRequestEvent event, Emitter<UserState> emit) async {
  //
  //   try {
  //
  //     emit(LoadingUserState());
  //
  //     final data = await userService.acceptFollowerRequest(event.uidFriend, event.uidNotification);
  //
  //     if(data.resp){
  //
  //       final data = await userService.getUserById();
  //
  //       emit( SuccessUserState() );
  //
  //       emit( state.copyWith(user: data.user, postsUser: data.postsUser));
  //
  //     }else {
  //       FailureUserState(data.message);
  //     }
  //
  //   } catch (e) {
  //     emit(FailureUserState(e.toString()));
  //   }
  // }
  //
  //
  // Future<void> _deleteFollowing(OnDeletefollowingEvent event, Emitter<UserState> emit) async {
  //
  //   try {
  //
  //     emit(LoadingFollowingUser());
  //
  //     final data = await userService.deleteFollowing(event.uidUser);
  //
  //     if(data.resp){
  //
  //       final data = await userService.getUserById();
  //
  //       emit( SuccessFollowingUser() );
  //
  //       emit( state.copyWith(user: data.user, postsUser: data.postsUser));
  //
  //     }else{
  //       emit(FailureUserState(data.message));
  //     }
  //
  //   } catch (e) {
  //     emit(FailureUserState(e.toString()));
  //   }
  //
  // }
  //
  //
  // Future<void> _deleteFollowers(OnDeletefollowersEvent event, Emitter<UserState> emit) async {
  //
  //   try {
  //
  //     emit(LoadingFollowersUser());
  //
  //     final data = await userService.deleteFollowers(event.uidUser);
  //
  //     if(data.resp){
  //
  //       final data = await userService.getUserById();
  //
  //       emit( SuccessFollowersUser() );
  //
  //       emit( state.copyWith(user: data.user, postsUser: data.postsUser));
  //
  //     }else{
  //       emit(FailureUserState(data.message));
  //     }
  //
  //   } catch (e) {
  //     emit(FailureUserState(e.toString()));
  //   }
  //
  // }

}
