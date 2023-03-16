import 'package:mychat_app/models/login_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginChangePasswordIconState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final LoginModel loginModel;

  LoginSuccessState(this.loginModel);
}

class LoginErrorState extends LoginState {
  final String error;
  LoginErrorState(this.error);
}

class LoginSendCodeSuccessState extends LoginState {}

class LoginVerifyCodeLoadingState extends LoginState {}

class LoginVerifyCodeSuccessState extends LoginState {
  final String uId;
  LoginVerifyCodeSuccessState(this.uId);
}

class LoginVerifyCodeErrorState extends LoginState {}