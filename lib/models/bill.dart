import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Bill {
  String? id;
  String? userId;
  String name;
  double? value;
  Map<String, bool> payments;
  Map<String, String> barCode;
  int? monthlydueDay;
  int? startDate;
  int? ammountMonths;
  bool? isActive;

  Bill({
    this.id,
    this.userId,
    required this.name,
    this.value,
    required this.payments,
    required this.barCode,
    this.monthlydueDay,
    this.startDate,
    this.ammountMonths,
    this.isActive,
  });

  Bill copyWith({
    String? id,
    String? userId,
    String? name,
    double? value,
    Map<String, bool>? payments,
    Map<String, String>? barCode,
    int? monthlydueDay,
    int? startDate,
    int? ammountMonths,
    bool? isActive,
  }) {
    return Bill(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      value: value ?? this.value,
      payments: payments ?? this.payments,
      barCode: barCode ?? this.barCode,
      monthlydueDay: monthlydueDay ?? this.monthlydueDay,
      startDate: startDate ?? this.startDate,
      ammountMonths: ammountMonths ?? this.ammountMonths,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'value': value,
      'payments': payments,
      'barCode': barCode,
      'monthlydueDay': monthlydueDay,
      'startDate': startDate,
      'ammountMonths': ammountMonths,
      'isActive': isActive,
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      id: map['id'],
      userId: map['userId'],
      name: map['name'] ?? '',
      value: map['value']?.toDouble(),
      payments: Map<String, bool>.from(map['payments']),
      barCode: Map<String, String>.from(map['barCode']),
      monthlydueDay: map['monthlydueDay']?.toInt(),
      startDate: map['startDate']?.toInt(),
      ammountMonths: map['ammountMonths']?.toInt(),
      isActive: map['isActive'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Bill.fromJson(String source) => Bill.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Bill(id: $id, userId: $userId, name: $name, value: $value, payments: $payments, barCode: $barCode, monthlydueDay: $monthlydueDay, startDate: $startDate, ammountMonths: $ammountMonths, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Bill &&
        other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.value == value &&
        mapEquals(other.payments, payments) &&
        mapEquals(other.barCode, barCode) &&
        other.monthlydueDay == monthlydueDay &&
        other.startDate == startDate &&
        other.ammountMonths == ammountMonths &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        name.hashCode ^
        value.hashCode ^
        payments.hashCode ^
        barCode.hashCode ^
        monthlydueDay.hashCode ^
        startDate.hashCode ^
        ammountMonths.hashCode ^
        isActive.hashCode;
  }

  static Color? getCurrentBillListTileColor(BuildContext context, Bill bill) {
    DateTime now = DateTime.now();
    DateTime? duedate = DateTime(now.year, now.month, bill.monthlydueDay!);
    Duration difference = duedate.difference(DateTime(now.year, now.month, now.day, 0, 0, 0));

    if (bill.payments.containsKey(duedate.toString())) {
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
