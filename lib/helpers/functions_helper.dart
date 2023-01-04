import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/shared/globals.dart';
import 'package:gastosrecorrentes/shared/string_constants.dart';

bool isNullOrEmpty(var item) {
  if (item == null || (item is String && item == '') || (item is List && item.isEmpty)) return true;
  return false;
}

scheduleCall(Function function) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    await function();
  });
}

String translateErrors(String? error) => MultiLanguage.translate(error ?? unkownError);

void showSnackBar(text, {duration}) {
  snackbarKey.currentState?.hideCurrentSnackBar();
  snackbarKey.currentState?.showSnackBar(SnackBar(
    content: Text(text),
    duration: duration ?? const Duration(seconds: 4),
    behavior: SnackBarBehavior.floating,
    elevation: 6,
  ));
}
