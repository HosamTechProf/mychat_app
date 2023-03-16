import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mychat_app/models/message_model.dart';
import 'package:mychat_app/models/user_model.dart';

import 'chat_state.dart';
import 'package:path/path.dart' as path;

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitial());

  static ChatCubit get(context) => BlocProvider.of(context);

  final CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('users');

  List<UserModel>? users;
  UserModel? userModel;

  Future<void> getUsers() async {
    emit(ChatLoadingState());
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
      final querySnapshot = await usersCollection.get();
      users = querySnapshot.docs
          .where((doc) => doc.id != currentUserUid)
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
      emit(ChatSuccessState(users!));
    } catch (e) {
      emit(ChatErrorState(e.toString()));
    }
  }

  //message data
  String? imageURL;
  bool isMessageImageLoading = false;
  List<MessageUserModel> message = [];
  File? messageImage;

  Future<void> sendMessage({
    required String? receiverId,
    required ChatMessageType type,
    String? text,
    File? file,
  }) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (type == ChatMessageType.image) {
      // upload the file to firebase storage
      final storageRef = FirebaseStorage.instance.ref().child(
          'chat_images/${path.basename(file!.path)}}');
      final uploadTask = storageRef.putFile(file);

      await uploadTask.whenComplete(() async {
        // get the download URL of the uploaded file
        final downloadUrl = await storageRef.getDownloadURL();

        // create message models for sender and receiver
        MessageUserModel senderMessage = MessageUserModel(
            senderId: currentUserUid,
            receiverId: receiverId,
            messageResource: downloadUrl,
            text: text,
            dateTime: Timestamp.fromDate(DateTime.now()),
            messageType: type.name,
            messageStatus: MessageStatus.not_view.name,
            isSender: true
        );

        MessageUserModel receiverMessage = MessageUserModel(
            senderId: currentUserUid,
            receiverId: receiverId,
            messageResource: downloadUrl,
            text: text,
            dateTime: Timestamp.fromDate(DateTime.now()),
            messageType: type.name,
            messageStatus: MessageStatus.not_view.name,
            isSender: false
        );

        // add messages to firestore
        await FirebaseFirestore.instance
            .collection('conversations')
            .doc(_getConversationId(currentUserUid!, receiverId!))
            .collection('messages')
            .add(senderMessage.toMap());

        await FirebaseFirestore.instance
            .collection('conversations')
            .doc(_getConversationId(receiverId!, currentUserUid!))
            .collection('messages')
            .add(receiverMessage.toMap());

        // update last message for both users
        await FirebaseFirestore.instance
            .collection('users')
            .doc(receiverId)
            .collection('chats')
            .doc(currentUserUid)
            .set({
          'lastMessage': receiverMessage.toMap(),
          'receiverId': currentUserUid,
        }, SetOptions(merge: true));

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserUid)
            .collection('chats')
            .doc(receiverId)
            .set({
          'lastMessage': senderMessage.toMap(),
          'receiverId': receiverId,
        }, SetOptions(merge: true));

        emit(SocialSendMessageSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialSendMessageErrorState());
      });
    } else {
      // create message models for sender and receiver
      MessageUserModel senderMessage = MessageUserModel(
          senderId: currentUserUid,
          receiverId: receiverId,
          messageResource: "",
          text: text,
          dateTime: Timestamp.fromDate(DateTime.now()),
          messageType: type.name,
          messageStatus: MessageStatus.not_view.name,
          isSender: true
      );

      MessageUserModel receiverMessage = MessageUserModel(
          senderId: currentUserUid,
          receiverId: receiverId,
          messageResource: "",
          text: text,
          dateTime: Timestamp.fromDate(DateTime.now()),
          messageType: type.name,
          messageStatus: MessageStatus.not_view.name,
          isSender: false
      );// add messages to firestore
      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(_getConversationId(currentUserUid!, receiverId!))
          .collection('messages')
          .add(senderMessage.toMap());

      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(_getConversationId(receiverId!, currentUserUid!))
          .collection('messages')
          .add(receiverMessage.toMap());

// update last message for both users
      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(currentUserUid)
          .set({
        'lastMessage': receiverMessage.toMap(),
        'receiverId': currentUserUid,
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .collection('chats')
          .doc(receiverId)
          .set({
        'lastMessage': senderMessage.toMap(),
        'receiverId': receiverId,
      }, SetOptions(merge: true));

      emit(SocialSendMessageSuccessState());
    }
  }


      Future<void> markMessagesAsViewed(String receiverId) async {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    final messagesRef = FirebaseFirestore.instance
        .collection('conversations')
        .doc(_getConversationId(currentUserUid!, receiverId))
        .collection('messages');

    final messages = await messagesRef
        .where('receiverId', isEqualTo: currentUserUid)
        .where('messageStatus', isEqualTo: MessageStatus.not_view.name)
        .get();

    WriteBatch batch = FirebaseFirestore.instance.batch();
    messages.docs.forEach((doc) {
      batch.update(doc.reference, {'messageStatus': MessageStatus.viewed.name});
    });
    await batch.commit();
  }

  String _getConversationId(String uid1, String uid2) {
    final uids = [uid1, uid2];
    uids.sort();
    return uids.join('_');
  }


  Future<File?> pickAndCompressImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        '${path.dirname(pickedFile.path)}/compressed_${path.basename(pickedFile.path)}',
        quality: 60,
      );
      emit(SocialAddPhotoState());
      return compressedImage;
    }
    return null;
  }


  List<MessageUserModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('conversations')
        .doc(_getConversationId(currentUserUid!, receiverId))
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        MessageUserModel message = MessageUserModel.fromJson(element.data());
        messages.add(message);
      }
      markMessagesAsViewed(receiverId);
      emit(SocialGetMessagesSuccessState());
    });
  }

}
