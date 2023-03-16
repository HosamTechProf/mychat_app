import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychat_app/layout/home_layout.dart';
import 'package:mychat_app/models/login_model.dart';
import 'package:mychat_app/modules/register_user_data/register_user_data_screen.dart';
import 'package:mychat_app/modules/verification/verification_screen.dart';
import 'package:mychat_app/network/local/cache_helper.dart';
import 'package:mychat_app/shared/components.dart';
import 'login_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;

  bool isPassword = true;
  IconData suffixIcon = Icons.visibility_off;

  FirebaseAuth auth = FirebaseAuth.instance;

  showPassword() {
    isPassword = !isPassword;
    suffixIcon = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(LoginChangePasswordIconState());
  }

  Future login({required String phone, required BuildContext context}) async {
    emit(LoginLoadingState());

    auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        verificationFailed: (FirebaseAuthException exception) {
          showToast(message: exception.message.toString(), color: Colors.red);
          print(exception.message);
          emit(LoginErrorState(exception.message.toString()));
        },
        codeSent: (String verificationId, int? token) {
          showToast(message: "Verification code sent successfully to $phone", color: Colors.green);
          navigateToAndKeep(
              context, VerificationScreen(verificationId: verificationId));
          emit(LoginSendCodeSuccessState());
        },
        codeAutoRetrievalTimeout: (e) {});
  }

  void verifyCode({required String verificationId, required String smsCode, required BuildContext context}) {
    emit(LoginVerifyCodeLoadingState());
    final credentials = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    auth.signInWithCredential(credentials).then((UserCredential value) async {
      // navigateToAndKeep(context, HomeLayout());
      print("User UID : ${value.user?.uid}");
      bool docExists = await checkIfDocExists(value.user!.uid);
      await CacheHelper.saveData(key: "docExists", value: docExists).then((value){
        if(docExists){
          navigateToAndKeep(context, HomeLayout());
        }else{
          navigateToAndKeep(context, RegisterUserDataScreen());
        }
      });

      emit(LoginVerifyCodeSuccessState(value.user!.uid));
    }).catchError((error){
      print(error.toString());
      emit(LoginVerifyCodeErrorState());
    });
  }


  /// Check If Document Exists
  Future<bool> checkIfDocExists(String docId) async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('users');
      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }
}
