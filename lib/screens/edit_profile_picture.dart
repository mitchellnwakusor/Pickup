import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../services/firebase_services.dart';
import '../widgets/widgets.dart';

class EditProfilePicturePage extends StatefulWidget {
  const EditProfilePicturePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePicturePage> createState() => _EditProfilePicturePageState();
}

class _EditProfilePicturePageState extends State<EditProfilePicturePage> {
  File? image;
  FirebaseStorageService storage = FirebaseStorageService();
  void useCamera() {}

  Future pickImage(BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        Navigator.pop(context);
        return;
      }

      final imageTemp = File(image.path);
      this.image = imageTemp;
      File file = File(image.path);
      setState(() {});
      await storage.uploadProfilePicture(file, context);
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
                titleText: e.code, contentText: e.message.toString());
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Edit profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            if (image != null) ...[
              Expanded(
                  flex: 2,
                  child: CircleAvatar(
                    minRadius: 80,
                    backgroundImage: FileImage(image!, scale: 0.4),
                    backgroundColor: Colors.white,
                  )),
            ] else ...[
              Expanded(
                  flex: 2,
                  child: CircleAvatar(
                    minRadius: 80,
                    backgroundImage:
                    const AssetImage('lib/assets/icons/blankPicture.png'),
                    backgroundColor: Colors.grey[300],
                  )),
            ],
            const SizedBox(height: 32),
            Expanded(
                flex: 2,
                child: Text(
                  'Please upload a passport photograph or selfie image with a white background.'
                      ' This image will be used as your profile picture within the app.',
                  style: Theme.of(context).textTheme.subtitle1,
                )),
            // const SizedBox(height: 16,),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          LoadingWidget().showLoadingWidget(context);
                          await pickImage(context);
                        },
                        icon: Icon(Icons.upload_file),
                        label: Text('UPLOAD PICTURE'),
                        style: Theme.of(context).elevatedButtonTheme.style,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       if (image == null) {
                    //         showDialog(
                    //             context: context,
                    //             builder: (BuildContext context) {
                    //               return const CustomDialog(
                    //                   titleText: 'No image uploaded',
                    //                   contentText:
                    //                   'Please upload a picture before continuing');
                    //             });
                    //       } else {
                    //         Navigator.pushNamed(context, '/addPaymentCard');
                    //       }
                    //     },
                    //     child: const Text('CONTINUE'),
                    //     style: Theme.of(context).elevatedButtonTheme.style,
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
