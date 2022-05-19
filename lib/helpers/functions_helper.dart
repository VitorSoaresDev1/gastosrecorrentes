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
