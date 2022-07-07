import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:gastosrecorrentes/components/dialogs/image_picker_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHandler {
  ImagePickerDialog? imagePickerDialog;
  final AnimationController _controller;
  ImagePicker imagePicker = ImagePicker();

  ImagePickerHandler(this._controller);

  Future<String?> openCamera(BuildContext context) async {
    String? imageString;
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imageString = await cropImage(image, context);
    }
    imagePickerDialog!.dismissDialog();
    return imageString;
  }

  Future<String?> openGallery(BuildContext context) async {
    String? imageString;
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageString = await cropImage(image, context);
    }
    imagePickerDialog!.dismissDialog();
    return imageString;
  }

  void init() {
    imagePickerDialog = ImagePickerDialog(this, _controller);
    imagePickerDialog!.initState();
  }

  Future<String?> cropImage(XFile image, BuildContext context) async {
    ImageCropper cropper = ImageCropper();
    CroppedFile? croppedFile = await cropper.cropImage(
      sourcePath: image.path,
    );
    if (croppedFile != null) {
      File imageFile = await compressFile(File(croppedFile.path));
      Uint8List image = await imageFile.readAsBytes();
      String imageString = base64.encode(image);
      return imageString;
    }
    return null;
  }

  Future<File> compressFile(File file) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: 50,
    );
    return compressedFile;
  }

  Future showDialog(BuildContext context) async {
    return await imagePickerDialog!.getImage(context);
  }
}
