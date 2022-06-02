import 'package:flutter/material.dart';

class PayInstallmentDialog extends StatelessWidget {
  const PayInstallmentDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Pay Installment"),
      content: const Text("Are you sure you would like set this installment as paid?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("confirm"),
        )
      ],
    );
  }
}
