import 'package:flutter/material.dart';
import 'package:mychat_app/models/message_model.dart';
import 'package:mychat_app/shared/constants.dart';
import 'package:photo_view/photo_view.dart';

class ImageMessage extends StatelessWidget {
  final MessageUserModel? message;

  const ImageMessage({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showOverlay(context, message);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
        child: Container(
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(message!.isSender! ? 1 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1.6,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Hero(
                        tag: message!.dateTime.toString(),
                        child: Image.network(message!.messageResource!),
                      ),
                    ),
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        size: 16,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 4, left: 5, top: 4, bottom: 6),
                child: Text(message!.text!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showOverlay(BuildContext context, MessageUserModel? message) async {
  await precacheImage(NetworkImage(message!.messageResource!), context);

  showDialog(
    context: context,
    builder: (_) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.7),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: Dismissible(
              key: Key(message.messageResource!),
              direction: DismissDirection.vertical,
              onDismissed: (_) => Navigator.of(context).pop(),
              child: Column(
                children: [
                  Expanded(
                    child: Hero(
                      tag: message.dateTime.toString(),
                      child: PhotoView(
                        imageProvider: NetworkImage(message.messageResource!),
                        maxScale: PhotoViewComputedScale.contained * 2.5,
                        minScale: PhotoViewComputedScale.contained,
                        backgroundDecoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    color: kContentColorLightTheme.withOpacity(0.8),
                    child: Text(
                      message.text!,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
