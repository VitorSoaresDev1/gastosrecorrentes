import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastosrecorrentes/helpers/currency_helper.dart';
import 'package:gastosrecorrentes/helpers/date_helper.dart';
import 'package:gastosrecorrentes/models/bill.dart';
import 'package:gastosrecorrentes/services/multi_language.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';
import 'package:time_machine/time_machine.dart';

class BillCard extends StatelessWidget {
  final Bill bill;
  final VoidCallback? onTap;
  const BillCard({
    Key? key,
    required this.bill,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Stack(
      children: [
        Container(
          height: 70,
          decoration: BoxDecoration(
            color: Bill.getCurrentBillListTileColor(context, bill),
            border: Border.all(color: Colors.grey, width: .3),
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(13),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ),
        Container(
          height: 68,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: .3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Material(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Theme.of(context).listTileTheme.tileColor,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(10),
                    splashColor: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(bill.name, style: TextStyles.titles2()),
                            const SizedBox(height: 8),
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
                                      " " + CurrencyHelper.formatDouble(bill.installments![0].price),
                                      style: TextStyles.bodyText(),
                                    ),
                                  ],
                                ),
                                Text(
                                    MultiLanguage.translate("dueTo") +
                                        ': ${DateHelper.formatDDMM(LocalDate(now.year, now.month, bill.monthlydueDay!))}',
                                    style: TextStyles.bodyText2()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                width: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
