import 'package:flutter/material.dart';

bool isNullOrEmpty(var item) {
  if (item == null || (item is String && item == '') || (item is List && item.isEmpty)) return true;
  return false;
}

scheduleCall(Function function) {
  WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
    await function();
  });
}

void showSnackBar(context, text, {duration}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: duration ?? const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    ),
  );
}
