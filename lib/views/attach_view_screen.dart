import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:provider/provider.dart';

class AttachmentViewScreen extends StatelessWidget {
  const AttachmentViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BillsViewModel billsViewModel = context.watch<BillsViewModel>();
    Uint8List imageByte = base64.decode(billsViewModel.currentSelectedInstallment!.attachment!);
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.black),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(0),
                  panEnabled: true,
                  minScale: .5,
                  maxScale: 4,
                  child: Image(image: MemoryImage(imageByte), fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
