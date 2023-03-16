import 'package:mychat_app/models/user_model.dart';

abstract class ChatStates {}

class ChatInitial extends ChatStates {}

class ChatLoadingState extends ChatStates {}

class ChatSuccessState extends ChatStates {
  final List<UserModel> users;

  ChatSuccessState(this.users);

  List<Object> get props => [users];
}

class ChatErrorState extends ChatStates {
  final String message;

  ChatErrorState(this.message);

  List<Object> get props => [message];
}


class SocialSendMessageSuccessState extends ChatStates {}

class SocialSendMessageErrorState extends ChatStates {}

class SocialGetMessageSuccessState extends ChatStates {}

class SocialGetMessagesSuccessState extends ChatStates {}

class SocialAddPhotoState extends ChatStates {}
