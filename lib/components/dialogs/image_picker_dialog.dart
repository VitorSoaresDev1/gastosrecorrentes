import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/services/local/image_picker_handler.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';

// ignore: must_be_immutable
class ImagePickerDialog extends StatelessWidget {
  final ImagePickerHandler _listener;
  final AnimationController _controller;
  String? imageString;
  BuildContext? context;
  Animation<double>? _drawerContentsOpacity;
  Animation<Offset>? _drawerDetailsPosition;

  ImagePickerDialog(this._listener, this._controller, {Key? key}) : super(key: key);

  void initState() {
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  Future<String?> getImage(BuildContext context) async {
    if (_drawerDetailsPosition == null || _drawerContentsOpacity == null) {
      return null;
    }
    _controller.forward();
    return showDialog(
      barrierDismissible: true,
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) => SlideTransition(
        position: _drawerDetailsPosition!,
        child: FadeTransition(
          opacity: ReverseAnimation(_drawerContentsOpacity!),
          child: this,
        ),
      ),
    );
  }

  void dispose() {
    _controller.dispose();
  }

  startTime() async {
    var _duration = const Duration(milliseconds: 200);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context!, imageString);
  }

  dismissDialog() {
    _controller.reverse();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Material(
      type: MaterialType.transparency,
      child: Opacity(
        opacity: 1.0,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () async => imageString = await _listener.openCamera(context),
                child: roundedButton(MultiLanguage.translate("camera"), const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0), Colors.white.withOpacity(.9), Colors.black87),
              ),
              GestureDetector(
                onTap: () async => imageString = await _listener.openGallery(context),
                child: roundedButton(MultiLanguage.translate("gallery"), const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0), Colors.white.withOpacity(.9), Colors.black87),
              ),
              const SizedBox(height: 15.0),
              GestureDetector(
                onTap: () => dismissDialog(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                  child: roundedButton(MultiLanguage.translate("cancel"), const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0), Colors.white.withOpacity(.9), Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget roundedButton(String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = Container(
      margin: margin,
      padding: const EdgeInsets.all(15.0),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            blurRadius: 5.0,
            offset: Offset(4.0, 3.0),
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: TextStyle(color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }
}
