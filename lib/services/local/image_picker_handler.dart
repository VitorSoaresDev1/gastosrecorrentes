import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/components/dialogs/image_picker_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHandler {
  ImagePickerDialog? imagePickerDialog;
  final AnimationController _controller;
  final ImagePickerListener _listener;
  ImagePicker imagePicker = ImagePicker();

  ImagePickerHandler(this._listener, this._controller);

  Future openCamera(BuildContext context) async {
    //locator<NavigationService>().navigateTo(context, CameraRoute);
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await cropImage(image);
    }
    imagePickerDialog!.dismissDialog();
    //locator<CameraRouteWidget>().pop();
    //SecureApplicationProvider.of(locator<Observables>().scaffoldContext).authSuccess(unlock: true);
    //locator<Observables>().authorized(true);
    //locator<Saw>().valueNotifier.unlock();
  }

  Future openGallery(BuildContext context) async {
    //locator<NavigationService>().navigateTo(context, CameraRoute);
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await cropImage(image);
    }
    imagePickerDialog!.dismissDialog();
    //locator<CameraRouteWidget>().pop();
    //SecureApplicationProvider.of(locator<Observables>().scaffoldContext).authSuccess(unlock: true);
    //locator<Observables>().authorized(true);
    //locator<Saw>().valueNotifier.unlock();
  }

  void init() {
    imagePickerDialog = ImagePickerDialog(this, _controller);
    imagePickerDialog!.initState();
  }

  Future cropImage(XFile image) async {
    ImageCropper cropper = ImageCropper();
    CroppedFile? croppedFile = await cropper.cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      maxWidth: 512,
      maxHeight: 512,
    );
    //salvar imagem banco
    File file = croppedFile as File;
    if (croppedFile != null) {
      print(file.readAsBytes());
    }
    _listener.userImage(file);
  }

  showDialog(BuildContext context) {
    imagePickerDialog!.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}
