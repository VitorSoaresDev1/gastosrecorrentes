import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastosrecorrentes/helpers/currency_helper.dart';
import 'package:gastosrecorrentes/helpers/date_helper.dart';
import 'package:gastosrecorrentes/models/bill.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';

class BillCard extends StatelessWidget {
  final Bill bill;
  const BillCard({
    Key? key,
    required this.bill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Theme.of(context).listTileTheme.tileColor,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bill.name, style: TextStyles.titles2()),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 2),
                              const Icon(FontAwesomeIcons.brazilianRealSign, size: 14),
                              Text(
                                " " + CurrencyHelper.formatDouble(bill.value),
                                style: TextStyles.bodyText(),
                              ),
                            ],
                          ),
                          Text(
                              'Vencimento: ${DateHelper.formatDDMM(DateTime(DateTime.now().year, DateTime.now().month, bill.monthlydueDay!))}',
                              style: TextStyles.bodySubtitle()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    width: 16,
                    decoration: BoxDecoration(
                      color: Bill.getCurrentBillListTileColor(context, bill),
                      borderRadius:
                          const BorderRadius.only(topRight: Radius.circular(9), bottomRight: Radius.circular(9)),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
