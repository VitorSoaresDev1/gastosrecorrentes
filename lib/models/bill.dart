// To parse this JSON data, do
//
//     final bills = billsFromMap(jsonString);

import 'package:flutter/material.dart';
import 'dart:convert';

class Bill {
  Bill({
    this.id,
    this.title = '',
    this.value,
    this.isPaid = false,
    this.monthlydueDate,
    this.finalPayment,
  });

  int? id;
  String title;
  double? value;
  bool isPaid;
  DateTime? monthlydueDate;
  DateTime? finalPayment;

  Bill copyWith({
    int? id,
    String? title,
    double? value,
    bool? isPaid,
    DateTime? monthlydueDate,
    DateTime? finalPayment,
  }) =>
      Bill(
        id: id ?? this.id,
        title: title ?? this.title,
        value: value ?? this.value,
        isPaid: isPaid ?? this.isPaid,
        monthlydueDate: monthlydueDate ?? this.monthlydueDate,
        finalPayment: finalPayment ?? this.finalPayment,
      );

  factory Bill.fromJson(String str) => Bill.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Bill.fromMap(Map<String, dynamic> json) => Bill(
        id: json["id"],
        title: json["title"],
        value: json["value"].toDouble(),
        isPaid: json["isPaid"],
        monthlydueDate: json["monthlydueDate"] == null ? null : DateTime.parse(json["monthlydueDate"]),
        finalPayment: json["finalPayment"] == null ? null : DateTime.parse(json["finalPayment"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "value": value,
        "isPaid": isPaid,
        "monthlydueDate": monthlydueDate?.toIso8601String(),
        "finalPayment": finalPayment?.toIso8601String(),
      };

  static Color? getCurrentBillListTileColor(BuildContext context, Bill bill) {
    DateTime? duedate = bill.monthlydueDate;
    if (duedate == null) return Theme.of(context).listTileTheme.tileColor;
    Duration difference = duedate.difference(DateTime.now());

    if (bill.isPaid) {
      return Colors.green[800]?.withOpacity(.8);
    } else if (difference.inDays < 1) {
      return Colors.red[800]?.withOpacity(.8);
    } else if (difference.inDays < 3) {
      return Colors.yellow[700]?.withOpacity(.8);
    } else {
      return Colors.grey.withOpacity(.8);
    }
  }
}
