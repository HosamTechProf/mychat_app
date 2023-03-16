import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychat_app/shared/components.dart';
import 'package:mychat_app/shared/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mychat_app/shared/cubit/register_user_data_cubit/register_user_data_cubit.dart';
import 'package:mychat_app/shared/cubit/register_user_data_cubit/register_user_data_state.dart';

class RegisterUserDataScreen extends StatelessWidget {
  var nameController = TextEditingController();
  File? image;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterUserDataCubit(),
      child: BlocConsumer<RegisterUserDataCubit, RegisterUserDataStates>(
        listener: (context, state) {
          if (state is RegisterUserDataPickImageState) {
            image = state.image;
          }
        },
        builder: (context, state) {
          RegisterUserDataCubit cubit = RegisterUserDataCubit().get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        cubit.pickImage(context: context);
                      },
                      child: image?.path.isEmpty ?? true
                          ? Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      AssetImage("assets/images/user.png"),
                                ),
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor:
                                      Colors.black.withOpacity(0.3),
                                  child: Icon(
                                    Icons.add_photo_alternate,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            )
                          : Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                            FileImage(image!),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    defaultFormField(
                      controller: nameController,
                      prefix: Icons.account_circle,
                      label: "Your Name",
                      keyboardType: TextInputType.name,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please Type Your Name";
                        }
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    defaultButton(
                      background: Constants.mainColor,
                      function: () async {
                        cubit.registerData(name: nameController.text, photo: image!.readAsBytesSync(), context: context);
                      },
                      text: "Save Data",
                    )
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
