import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/components/bill_details/bill_detail_drop_down_menu.dart';
import 'package:gastosrecorrentes/components/bill_details/bill_summary.dart';
import 'package:gastosrecorrentes/components/bill_details/installment_components/installments_animated_list.dart';
import 'package:gastosrecorrentes/models/bill.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:provider/provider.dart';

class BillDetailsScreen extends StatelessWidget {
  const BillDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BillsViewModel billsViewModel = context.watch<BillsViewModel>();
    final Bill currentBill = billsViewModel.currentSelectedBill!;
    return Scaffold(
      appBar: AppBar(
        title: Text(currentBill.name),
        elevation: 0,
        actions: [
          BillDetailDropdownMenu(bill: currentBill),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            Column(children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.indigo,
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ]),
            ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                const BillSummary(),
                const SizedBox(height: 8),
                InstallmentsAnimatedList(billsViewModel: billsViewModel)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
