import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mychat_app/layout/home_layout.dart';
import 'package:mychat_app/modules/chats/chats_screen.dart';
import 'package:mychat_app/network/local/cache_helper.dart';
import 'package:mychat_app/shared/components.dart';
import 'package:mychat_app/shared/cubit/register_user_data_cubit/register_user_data_state.dart';

class RegisterUserDataCubit extends Cubit<RegisterUserDataStates> {
  RegisterUserDataCubit() : super(RegisterUserDataInitial());

  RegisterUserDataCubit get(context) => BlocProvider.of(context);

  pickImage({required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Photo',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.deepOrange,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      emit(RegisterUserDataPickImageState(File(croppedFile!.path)));
    }
  }

  Future<void> registerData({required String name, required Uint8List photo, required BuildContext context}) async {
    final authUser = FirebaseAuth.instance.currentUser;
    final DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(authUser?.uid);

    try {
      // Upload the photo to Firebase Storage
      final Reference storageRef = FirebaseStorage.instance.ref().child('user_photos').child('${authUser?.uid}.jpg');
      final UploadTask uploadTask = storageRef.putData(photo);
      final TaskSnapshot downloadUrl = await uploadTask;
      final String photoUrl = await downloadUrl.ref.getDownloadURL();

      // Save user data to Firestore
      await userRef.set({
        'name': name,
        'photo': photoUrl,
        'uId': authUser?.uid,
        'phone': authUser?.phoneNumber
      });

      showToast(message: "Registered Successfully", color: Colors.green);
      await CacheHelper.saveData(key: "docExists", value: true).then((value){
        navigateToAndKeep(context, ChatsScreen());
        emit(RegisterUserDataSuccessState());
      });
    } catch (e) {
      showToast(message: "Error", color: Colors.red);
      emit(RegisterUserDataErrorState());
    }
  }

}
