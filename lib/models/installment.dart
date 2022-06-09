import 'dart:convert';

import 'package:flutter/material.dart';

class Installment {
  String id;
  int index;
  DateTime dueDate;
  double price;
  bool isLate;
  bool isPaid;
  Installment({
    required this.id,
    required this.index,
    required this.dueDate,
    required this.price,
    required this.isLate,
    required this.isPaid,
  });

  Installment copyWith({
    String? id,
    int? index,
    DateTime? dueDate,
    double? price,
    bool? isLate,
    bool? isPaid,
  }) {
    return Installment(
      id: id ?? this.id,
      index: index ?? this.index,
      dueDate: dueDate ?? this.dueDate,
      price: price ?? this.price,
      isLate: isLate ?? this.isLate,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'index': index,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'price': price,
      'isLate': isLate,
      'isPaid': isPaid,
    };
  }

  factory Installment.fromMap(Map<String, dynamic> map) {
    return Installment(
      id: map['id'] ?? '',
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
    return 'Installment(id: $id, index: $index, dueDate: $dueDate, price: $price, isLate: $isLate, isPaid: $isPaid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Installment &&
        other.id == id &&
        other.index == index &&
        other.dueDate == dueDate &&
        other.price == price &&
        other.isLate == isLate &&
        other.isPaid == isPaid;
  }

  @override
  int get hashCode {
    return id.hashCode ^ index.hashCode ^ dueDate.hashCode ^ price.hashCode ^ isLate.hashCode ^ isPaid.hashCode;
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
