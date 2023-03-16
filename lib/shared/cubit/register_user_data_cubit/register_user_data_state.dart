import 'dart:io';

abstract class RegisterUserDataStates {}

class RegisterUserDataInitial extends RegisterUserDataStates {}

class RegisterUserDataPickImageState extends RegisterUserDataStates {
  final File image;
  RegisterUserDataPickImageState(this.image);
}

class RegisterUserDataSuccessState extends RegisterUserDataStates {}

class RegisterUserDataErrorState extends RegisterUserDataStates {}

