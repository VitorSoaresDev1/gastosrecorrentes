import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/helpers/date_helper.dart';
import 'package:gastosrecorrentes/models/bill.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';

class InstallmentCard extends StatelessWidget {
  final Bill bill;
  final int index;
  final VoidCallback? onTap;
  const InstallmentCard({
    Key? key,
    required this.bill,
    this.onTap,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateAux = DateTime.fromMillisecondsSinceEpoch(bill.startDate!);
    DateTime installmentDateAux = DateTime(dateAux.year, dateAux.month, 1).add(Duration(days: (28.5 * index).round()));
    DateTime currentInstallmentDate = DateTime(installmentDateAux.year, installmentDateAux.month, bill.monthlydueDay!);
    List paid = bill.isPaid?.values.toList() ?? [];
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Theme.of(context).listTileTheme.tileColor,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: .5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("$index.   ", style: TextStyles.bodySubtitle()),
                          Text(DateHelper.formatDDMMYYYY(currentInstallmentDate), style: TextStyles.bodySubtitle()),
                        ],
                      ),
                      if (paid.length >= index && paid[index - 1] == true)
                        Text("Pago", style: TextStyles.bodyText())
                      else
                        Text("Pendente", style: TextStyles.bodyText())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
