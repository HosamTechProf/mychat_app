import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychat_app/models/message_model.dart';
import 'package:mychat_app/shared/constants.dart';
import 'package:mychat_app/shared/cubit/chat_cubit/chat_cubit.dart';
import 'package:mychat_app/shared/cubit/chat_cubit/chat_state.dart';

class SendPhotoView extends StatelessWidget {
  SendPhotoView({super.key, required this.image, required this.receiverId});

  final File? image;
  final String? receiverId;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.file(
              image!,
            ),
          ),
          BlocProvider(
            create: (context) => ChatCubit(),
            child: BlocBuilder<ChatCubit, ChatStates>(
              builder: (context, state) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding / 2,
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: kDefaultPadding * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: kContentColorLightTheme,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.textsms_outlined,
                                  color: Colors.white,
                                ),
                                SizedBox(width: kDefaultPadding),
                                Expanded(
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    maxLines: 4,
                                    minLines: 1,
                                    controller: controller,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color: Colors.white
                                      ),
                                      hintText: "Add a caption...",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.white,),
                          onPressed: () {
                            ChatCubit.get(context).sendMessage(receiverId: receiverId, type: ChatMessageType.image,text: controller.text,file: image).then((value){
                              Navigator.pop(context);
                            });
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
