import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychat_app/models/Chat.dart';
import 'package:mychat_app/modules/chats/components/chat_card.dart';
import 'package:mychat_app/modules/messages/message_screen.dart';
import 'package:mychat_app/shared/components/filled_outline_button.dart';
import 'package:mychat_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:mychat_app/shared/cubit/chat_cubit/chat_cubit.dart';
import 'package:mychat_app/shared/cubit/chat_cubit/chat_state.dart';


class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _selectedIndex = 0;
  late final ChatCubit _chatCubit;

  @override
  void initState() {
    super.initState();
    _chatCubit = ChatCubit()..getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
                kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
            color: kPrimaryColor,
            child: Row(
              children: [
                FillOutlineButton(press: () {}, text: "Recent Message"),
                SizedBox(width: kDefaultPadding),
                FillOutlineButton(
                  press: () {},
                  text: "Active",
                  isFilled: false,
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocProvider(
              create: (context) => _chatCubit,
              child: BlocConsumer<ChatCubit, ChatStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is ChatLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if(state is ChatSuccessState) {
                    final users = state.users;
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: users.length, // Use users instead of chatsData
                      itemBuilder: (context, index) => ChatCard(
                        chat: users[index], // Use users instead of chatsData
                        press: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessagesScreen(
                              userData : users[index]
                            ),
                          ),
                        ),
                      ),
                    );
                  }else{
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.person_add_alt_1,
          color: Colors.white,
        ),
      ),
      // bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "People"),
        BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
          label: "Profile",
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text("Chats"),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }
}
