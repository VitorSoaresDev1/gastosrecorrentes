import 'dart:convert';

import 'package:flutter/material.dart';

class Installment {
  int index;
  DateTime dueDate;
  double price;
  bool isLate;
  bool isPaid;
  Installment({
    required this.index,
    required this.dueDate,
    required this.price,
    required this.isLate,
    required this.isPaid,
  });

  Installment copyWith({
    int? index,
    DateTime? dueDate,
    double? price,
    bool? isLate,
    bool? isPaid,
  }) {
    return Installment(
      index: index ?? this.index,
      dueDate: dueDate ?? this.dueDate,
      price: price ?? this.price,
      isLate: isLate ?? this.isLate,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'price': price,
      'isLate': isLate,
      'isPaid': isPaid,
    };
  }

  factory Installment.fromMap(Map<String, dynamic> map) {
    return Installment(
      index: map['index']?.toInt() ?? 0,
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate']),
      price: map['price']?.toDouble() ?? 0.0,
      isLate: map['isLate'] ?? false,
      isPaid: map['isPaid'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Installment.fromJson(String source) => Installment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Installment(index: $index, dueDate: $dueDate, price: $price, isLate: $isLate, isPaid: $isPaid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Installment &&
        other.index == index &&
        other.dueDate == dueDate &&
        other.price == price &&
        other.isLate == isLate &&
        other.isPaid == isPaid;
  }

  @override
  int get hashCode {
    return index.hashCode ^ dueDate.hashCode ^ price.hashCode ^ isLate.hashCode ^ isPaid.hashCode;
  }

  static Color getInstallmentColor(BuildContext context, Installment installment) {
    if (installment.isPaid) {
      return Colors.green[800]!.withOpacity(.8);
    } else if (installment.isLate) {
      return Colors.red[800]!.withOpacity(.8);
    } else {
      return Colors.grey[700]!;
    }
  }
}
