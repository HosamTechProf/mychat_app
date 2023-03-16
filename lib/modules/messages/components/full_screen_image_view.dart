import 'package:flutter/material.dart';
import 'package:mychat_app/models/message_model.dart';
import 'package:mychat_app/shared/constants.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenPhotoView extends StatelessWidget {
  final MessageUserModel message;

  const FullScreenPhotoView({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          // Close the photo view if swipe distance is more than 100 pixels
          if (details.primaryVelocity! > 100 || details.primaryVelocity! < -100) {
            Navigator.pop(context);
          }
        },
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: PhotoView(
                  imageProvider: NetworkImage(message.messageResource!),
                  maxScale: PhotoViewComputedScale.contained * 2.5,
                  minScale: PhotoViewComputedScale.contained,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: kContentColorLightTheme.withOpacity(0.5),
                child: Text(
                  message.text!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                  ),
                ),
              ),
              SizedBox(height: 15,)
            ],
          ),
        ),
      ),
    );
  }
}
