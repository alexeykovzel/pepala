import 'package:flutter/material.dart';
import 'package:pepala/core/models/photo.dart';
import 'package:pepala/core/providers/auth/create_profile.dart';
import 'package:pepala/widgets/custom_buttons.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class AddProfilePicturePage extends StatelessWidget {
  const AddProfilePicturePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: ChangeNotifierProvider(
            create: (_) => PhotoModel(),
            child: Column(
              children: [
                const SizedBox(height: 100),
                const Text(
                  "Add profile photo",
                  style: TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 40),
                const _ProfilePhoto(),
                const Expanded(child: SizedBox()),
                NavigationButton(
                    callback: context.read<CreateProfileProvider>().uploadPhoto),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  final double _kBorderRadius = 10;

  const _ProfilePhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PhotoModel>(
      builder: (context, photo, child) => Stack(
        alignment: Alignment.topCenter,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => showModalBottomSheet(
                builder: (context) => SizedBox(
                      height: 70,
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          IconButton(
                            onPressed: () => photo.onImageButtonPressed(
                                ImageSource.gallery, context),
                            icon: const Icon(Icons.collections, size: 35),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () => photo.onImageButtonPressed(
                                ImageSource.camera, context),
                            icon: const Icon(Icons.photo_camera, size: 35),
                          ),
                        ],
                      ),
                    ),
                context: context),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(_kBorderRadius),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_kBorderRadius),
                child: SizedBox(
                  width: 280,
                  height: 280,
                  child: photo.previewImage(context,
                      blankImage: const Icon(
                        Icons.add,
                        size: 120,
                        color: Colors.black12,
                      )),
                ),
              ),
            ),
          ),

          /// Shows a gallery image at the top right corner
          /// whenever there is a photo uploaded.
          if (photo.hasPhoto())
            Container(
              alignment: Alignment.centerRight,
              child: const Icon(Icons.collections),
            ),
        ],
      ),
    );
  }
}
