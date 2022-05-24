import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Bill {
  String? userId;
  String name;
  double? value;
  Map<List<int>, bool>? isPaid;
  Map<List<int>, String>? barCode;
  int? monthlydueDay;
  DateTime? startDate;
  int? ammountMonths;
  Bill({
    this.userId,
    required this.name,
    this.value,
    this.isPaid,
    this.barCode,
    this.monthlydueDay,
    this.startDate,
    this.ammountMonths,
  });

  Bill copyWith({
    String? userId,
    String? name,
    double? value,
    Map<List<int>, bool>? isPaid,
    Map<List<int>, String>? barCode,
    int? monthlydueDay,
    DateTime? startDate,
    int? ammountMonths,
  }) {
    return Bill(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      value: value ?? this.value,
      isPaid: isPaid ?? this.isPaid,
      barCode: barCode ?? this.barCode,
      monthlydueDay: monthlydueDay ?? this.monthlydueDay,
      startDate: startDate ?? this.startDate,
      ammountMonths: ammountMonths ?? this.ammountMonths,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'value': value,
      'isPaid': isPaid,
      'barCode': barCode,
      'monthlydueDay': monthlydueDay,
      'startDate': startDate?.millisecondsSinceEpoch,
      'ammountMonths': ammountMonths,
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      userId: map['userId'],
      name: map['name'] ?? '',
      value: map['value']?.toDouble(),
      isPaid: map['isPaid'] != null ? Map<List<int>, bool>.from(map['isPaid']) : null,
      barCode: map['barCode'] != null ? Map<List<int>, String>.from(map['barCode']) : null,
      monthlydueDay: map['monthlydueDay']?.toInt(),
      startDate: map['startDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['startDate']) : null,
      ammountMonths: map['ammountMonths']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Bill.fromJson(String source) => Bill.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Bill(userId: $userId, name: $name, value: $value, isPaid: $isPaid, barCode: $barCode, monthlydueDay: $monthlydueDay, startDate: $startDate, ammountMonths: $ammountMonths)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Bill &&
        other.userId == userId &&
        other.name == name &&
        other.value == value &&
        mapEquals(other.isPaid, isPaid) &&
        mapEquals(other.barCode, barCode) &&
        other.monthlydueDay == monthlydueDay &&
        other.startDate == startDate &&
        other.ammountMonths == ammountMonths;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        name.hashCode ^
        value.hashCode ^
        isPaid.hashCode ^
        barCode.hashCode ^
        monthlydueDay.hashCode ^
        startDate.hashCode ^
        ammountMonths.hashCode;
  }

  static Color? getCurrentBillListTileColor(BuildContext context, Bill bill) {
    DateTime? duedate = DateTime(DateTime.now().year, DateTime.now().month, bill.monthlydueDay!);
    Duration difference = duedate.difference(DateTime.now());

    if (bill.isPaid?[0] == true) {
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
