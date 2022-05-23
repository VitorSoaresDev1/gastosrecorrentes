import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/services/multi_language.dart';

class CreateBillScreen extends StatelessWidget {
  const CreateBillScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(MultiLanguage.translate("createNewBill"))),
      body: const Center(
        child: Text("Create Bill"),
      ),
    );
  }
}
