import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychat_app/network/local/cache_helper.dart';
import 'package:mychat_app/shared/components.dart';
import 'package:mychat_app/shared/constants.dart';
import 'package:mychat_app/shared/cubit/login_cubit/login_cubit.dart';
import 'package:mychat_app/shared/cubit/login_cubit/login_state.dart';

class VerificationScreen extends StatelessWidget {

  final String verificationId;

  VerificationScreen({required this.verificationId});

  var codeController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if(state is LoginVerifyCodeSuccessState){
            CacheHelper.saveData(key: "uId", value: state.uId.toString());
          }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultFormField(
                      controller: codeController,
                      prefix: Icons.numbers,
                      label: "6-Digit Code",
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Value can not be empty";
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    state is! LoginVerifyCodeLoadingState
                        ? defaultButton(
                      background: kPrimaryColor,
                      function: () {
                        if (formKey.currentState!.validate()) {
                          cubit.verifyCode(verificationId: verificationId, smsCode: codeController.text, context: context);
                        }
                      },
                      text: "Verify",
                    )
                        : Center(child: CircularProgressIndicator())
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
