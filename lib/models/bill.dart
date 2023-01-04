import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:gastosrecorrentes/models/installment.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:provider/provider.dart';

class Bill {
  String? id;
  String? userId;
  String name;
  double? value;
  int? monthlydueDay;
  int? startDate;
  int? ammountMonths;
  bool? isActive;
  List<Installment>? installments;

  Bill({
    this.id,
    this.userId,
    required this.name,
    this.value,
    this.monthlydueDay,
    this.startDate,
    this.ammountMonths,
    this.isActive,
    required this.installments,
  });

  Bill copyWith({
    String? id,
    String? userId,
    String? name,
    double? value,
    int? monthlydueDay,
    int? startDate,
    int? ammountMonths,
    bool? isActive,
    List<Installment>? installments,
  }) {
    return Bill(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      value: value ?? this.value,
      monthlydueDay: monthlydueDay ?? this.monthlydueDay,
      startDate: startDate ?? this.startDate,
      ammountMonths: ammountMonths ?? this.ammountMonths,
      isActive: isActive ?? this.isActive,
      installments: installments ?? this.installments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'value': value,
      'monthlydueDay': monthlydueDay,
      'startDate': startDate,
      'ammountMonths': ammountMonths,
      'isActive': isActive,
      'installments': installments?.map((x) => x.toMap()).toList(),
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      id: map['id'],
      userId: map['userId'],
      name: map['name'] ?? '',
      value: map['value']?.toDouble(),
      monthlydueDay: map['monthlydueDay']?.toInt(),
      startDate: map['startDate']?.toInt(),
      ammountMonths: map['ammountMonths']?.toInt(),
      isActive: map['isActive'],
      installments: map['installments'] != null
          ? List<Installment>.from(map['installments']?.map((x) => Installment.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Bill.fromJson(String source) => Bill.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Bill(id: $id, userId: $userId, name: $name, value: $value, monthlydueDay: $monthlydueDay, startDate: $startDate, ammountMonths: $ammountMonths, isActive: $isActive, installments: $installments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Bill &&
        other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.value == value &&
        other.monthlydueDay == monthlydueDay &&
        other.startDate == startDate &&
        other.ammountMonths == ammountMonths &&
        other.isActive == isActive &&
        listEquals(other.installments, installments);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        name.hashCode ^
        value.hashCode ^
        monthlydueDay.hashCode ^
        startDate.hashCode ^
        ammountMonths.hashCode ^
        isActive.hashCode ^
        installments.hashCode;
  }

  static Color? getCurrentBillListTileColor(BuildContext context, Bill bill) {
    DateTime now = DateTime.now();
    Installment currentInstallment =
        Provider.of<BillsViewModel>(context, listen: false).getCurrentMonthInstallment(bill);
    DateTime? duedate =
        DateTime(currentInstallment.dueDate.year, currentInstallment.dueDate.month, bill.monthlydueDay!);
    Duration difference = duedate.difference(DateTime(now.year, now.month, now.day, 0, 0, 0));
    if (bill.installments!.where((element) => element.isLate == true && !element.isPaid).isNotEmpty) {
      return Colors.red[800]?.withOpacity(.8);
    } else if (bill.installments!.where((element) => element.dueDate == duedate && element.isPaid).isNotEmpty) {
      return Colors.green[800]?.withOpacity(.8);
    } else if (difference.inDays <= 1) {
      return Colors.red[800]?.withOpacity(.8);
    } else if (difference.inDays <= 3) {
      return Colors.yellow[700]?.withOpacity(.8);
    } else {
      return Colors.grey.withOpacity(.8);
    }
  }
}
