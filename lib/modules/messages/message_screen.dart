import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychat_app/models/message_model.dart';
import 'package:mychat_app/models/user_model.dart';
import 'package:mychat_app/modules/messages/components/message.dart';
import 'package:mychat_app/modules/send_photo_view/send_photo_view.dart';
import 'package:mychat_app/shared/components.dart';
import 'package:mychat_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:mychat_app/shared/cubit/chat_cubit/chat_cubit.dart';
import 'package:mychat_app/shared/cubit/chat_cubit/chat_state.dart';

class MessagesScreen extends StatefulWidget {

  final UserModel userData;


  MessagesScreen({super.key, required this.userData});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  TextEditingController inputController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  late ChatCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ChatCubit()..getMessages(receiverId: widget.userData.uId!);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(photo:widget.userData.photo, name:widget.userData.name),
      body: BlocProvider.value(
        value: _cubit,
        child: Builder(
          builder: (context) {
            // ChatCubit.get(context).getMessages(
            //   receiverId: widget.userData.uId!,
            // );
            return BlocConsumer<ChatCubit, ChatStates>(
              listener: (context, state) {},
              builder: (context, state) {
                ChatCubit cubit = ChatCubit.get(context);
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: cubit.messages.length,
                          controller: scrollController,
                          itemBuilder: (context, index) =>
                              Message(message: cubit.messages[index], photo: widget.userData.photo),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: kDefaultPadding,
                        vertical: kDefaultPadding / 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 32,
                            color: Color(0xFF087949).withOpacity(0.08),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Row(
                          children: [
                            Icon(Icons.mic, color: kPrimaryColor),
                            SizedBox(width: kDefaultPadding),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding * 0.75,
                                ),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.sentiment_satisfied_alt_outlined,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color!
                                          .withOpacity(0.64),
                                    ),
                                    SizedBox(width: kDefaultPadding / 4),
                                    Expanded(
                                      child: TextFormField(
                                        controller: inputController,
                                        decoration: InputDecoration(
                                          hintText: "Type message",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    // Icon(
                                    //   Icons.attach_file,
                                    //   color: Theme.of(context)
                                    //       .textTheme
                                    //       .bodyText1!
                                    //       .color!
                                    //       .withOpacity(0.64),
                                    // ),
                                    // SizedBox(width: kDefaultPadding / 4),
                                    IconButton(
                                      icon: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color!
                                            .withOpacity(0.64),
                                      ),
                                      onPressed: () {
                                        cubit.pickAndCompressImage().then((value) {
                                          navigateTo(context, SendPhotoView(image: value, receiverId: widget.userData.uId));
                                          cubit.close();
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                cubit.sendMessage(text: inputController.text, receiverId: widget.userData.uId, type: ChatMessageType.text);
                                inputController.clear();
                                scrollController.jumpTo(scrollController.position.maxScrollExtent);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        ),
      ),
    );
  }
}

AppBar buildAppBar({String? photo, String? name}) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        BackButton(),
        CircleAvatar(
          backgroundImage: NetworkImage(photo!),
        ),
        SizedBox(width: kDefaultPadding * 0.75),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name!,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Active 3m ago",
              style: TextStyle(fontSize: 12),
            )
          ],
        )
      ],
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.local_phone),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(Icons.videocam),
        onPressed: () {},
      ),
      SizedBox(width: kDefaultPadding / 2),
    ],
  );
}