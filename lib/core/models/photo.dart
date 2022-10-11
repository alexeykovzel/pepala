import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PhotoModel extends ChangeNotifier {
  final _picker = ImagePicker();
  dynamic _pickImageError;
  String? _retrieveDataError;
  File? _imageFile;

  void onImageButtonPressed(ImageSource source, BuildContext context) async {
    /// Closes modal bottom sheet
    Navigator.pop(context);

    /// Picks an image from a provided source, resizes and
    /// compresses it to predefined parameters.
    /// Then, it asks the profile to crop it to a square.
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 960,
        maxHeight: 960,
        imageQuality: 90,
      );
      if (pickedFile != null) {
        _imageFile = await _cropImage(pickedFile);
      }
    } catch (e) {
      _pickImageError = e;
    }
    notifyListeners();
  }

  /// Uploads a user profile photo, otherwise returns a blank image.
  Widget previewImage(BuildContext context, {required Widget blankImage}) {
    return Platform.isAndroid
        ? FutureBuilder<void>(
            future: _retrieveLostData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.done:
                  if (_retrieveDataError != null) {
                    _onImageError(context, _retrieveDataError);
                    _retrieveDataError = null;
                    return blankImage;
                  }
                  return _retrieveImage(context) ?? blankImage;
                default:
                  if (snapshot.hasError) _onImageError(context, snapshot.error);
                  return blankImage;
              }
            },
          )
        : _retrieveImage(context) ?? blankImage;
  }

  /// Handles image errors.
  void _onImageError(BuildContext context, Object? msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image error: $msg')));
  }

  /// Tries to retrieve an image from a file.
  Image? _retrieveImage(BuildContext context) {
    if (_imageFile != null) {
      File file = File(_imageFile!.path);
      return Image.file(file, fit: BoxFit.fill);
    }
    if (_pickImageError != null) {
      _onImageError(context, _pickImageError);
    }
    return null;
  }

  /// Waits for the user to crop the image to a square.
  Future<File?> _cropImage(XFile image) async {
    return await ImageCropper().cropImage(
        cropStyle: CropStyle.rectangle,
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Pepala Cropper',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: const IOSUiSettings(
          title: 'Pepala Cropper',
        ));
  }

  /// Android system -- although very rarely -- sometimes kills the
  /// [MainActivity] after the [image_picker] finishes. When this happens,
  /// the data is retrieved from the model.
  Future<void> _retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (!response.isEmpty) {
      if (response.file != null && response.type == RetrieveType.image) {
        _imageFile = File(response.file!.path);
      } else {
        _retrieveDataError = response.exception!.code;
      }
    }
  }

  /// Deletes the uploaded photo.
  void deletePhoto() {
    _imageFile = null;
    notifyListeners();
  }

  /// Returns the image file.
  File? get imageFile => _imageFile;

  /// Returns true if the image has been uploaded.
  bool hasPhoto() => _imageFile != null;
}
