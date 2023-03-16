import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychat_app/shared/components.dart';
import 'package:mychat_app/shared/constants.dart';
import 'package:mychat_app/shared/cubit/login_cubit/login_cubit.dart';
import 'package:mychat_app/shared/cubit/login_cubit/login_state.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController phoneController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {},
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LOGIN",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 44.0,
                            ),
                          ),
                          Text(
                            "Login now and watch what is new.",
                            style: TextStyle(fontSize: 15.0),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          defaultFormField(
                            controller: phoneController,
                            prefix: Icons.phone,
                            label: "Phone Number",
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Phone Can't be empty";
                              }
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          state is! LoginLoadingState
                              ? defaultButton(
                                  background: kPrimaryColor,
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.login(phone: phoneController.text, context: context);
                                    }
                                  },
                                  text: "Login",
                                )
                              : Center(child: CircularProgressIndicator())
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
