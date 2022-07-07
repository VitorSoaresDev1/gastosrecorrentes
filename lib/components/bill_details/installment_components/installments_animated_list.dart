import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/components/bill_details/installment_components/installment_card.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';

class InstallmentsAnimatedList extends StatelessWidget {
  const InstallmentsAnimatedList({Key? key, required this.billsViewModel}) : super(key: key);

  final BillsViewModel billsViewModel;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      child: Container(
        padding: const EdgeInsets.only(top: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: AnimatedList(
            physics: const NeverScrollableScrollPhysics(),
            key: billsViewModel.animatedListKey,
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 16),
            itemBuilder: (context, index, animation) => InstallmentCard(
              index: index,
              installment: billsViewModel.currentSelectedBill!.installments![index],
              animation: animation,
            ),
            initialItemCount: billsViewModel.currentSelectedBill!.installments!.length,
          ),
        ),
      ),
    );
  }
}
