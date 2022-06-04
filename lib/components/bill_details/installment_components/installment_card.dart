import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/components/bill_details/installment_components/attachment_button.dart';
import 'package:gastosrecorrentes/components/bill_details/installment_components/change_value_button.dart';
import 'package:gastosrecorrentes/components/bill_details/installment_components/installment_summary.dart';
import 'package:gastosrecorrentes/components/bill_details/installment_components/pay_installment_button.dart';
import 'package:gastosrecorrentes/models/installment.dart';

class InstallmentCard extends StatelessWidget {
  final int index;
  final Installment installment;
  final VoidCallback? onTap;
  final Animation<double> animation;
  const InstallmentCard({Key? key, this.onTap, required this.installment, required this.animation, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Theme.of(context).listTileTheme.tileColor,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Installment.getInstallmentColor(context, installment)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InstallmentSummary(installment: installment),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Expanded(flex: 1, child: SizedBox()),
                              ChangeValueButton(installment: installment),
                              AttachmentButton(installment: installment),
                              PayInstallmentButton(installmentCard: this),
                            ],
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
