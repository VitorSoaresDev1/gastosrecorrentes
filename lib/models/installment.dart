import 'dart:convert';

import 'package:flutter/material.dart';

class Installment {
  String id;
  int index;
  DateTime dueDate;
  double price;
  bool isLate;
  bool isPaid;
  String? attachment;

  Installment({
    required this.id,
    required this.index,
    required this.dueDate,
    required this.price,
    required this.isLate,
    required this.isPaid,
    this.attachment,
  });

  Installment copyWith({
    String? id,
    int? index,
    DateTime? dueDate,
    double? price,
    bool? isLate,
    bool? isPaid,
    String? attachment,
  }) {
    return Installment(
      id: id ?? this.id,
      index: index ?? this.index,
      dueDate: dueDate ?? this.dueDate,
      price: price ?? this.price,
      isLate: isLate ?? this.isLate,
      isPaid: isPaid ?? this.isPaid,
      attachment: attachment ?? this.attachment,
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
      'attachment': attachment,
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
      attachment: map['attachment'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Installment.fromJson(String source) => Installment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Installment(id: $id, index: $index, dueDate: $dueDate, price: $price, isLate: $isLate, isPaid: $isPaid, attachment: $attachment)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Installment && other.id == id && other.index == index && other.dueDate == dueDate && other.price == price && other.isLate == isLate && other.isPaid == isPaid && other.attachment == attachment;
  }

  @override
  int get hashCode {
    return id.hashCode ^ index.hashCode ^ dueDate.hashCode ^ price.hashCode ^ isLate.hashCode ^ isPaid.hashCode ^ attachment.hashCode;
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
