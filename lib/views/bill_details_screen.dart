import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastosrecorrentes/components/bill_details/installment_card.dart';
import 'package:gastosrecorrentes/helpers/currency_helper.dart';
import 'package:gastosrecorrentes/helpers/date_helper.dart';
import 'package:gastosrecorrentes/models/bill.dart';
import 'package:gastosrecorrentes/services/multi_language.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:provider/provider.dart';

class BillDetailsScreen extends StatelessWidget {
  const BillDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billsViewModel = context.watch<BillsViewModel>();
    Bill currentBill = billsViewModel.currentSelectedBill!;
    DateTime dateAux = DateTime.fromMillisecondsSinceEpoch(currentBill.startDate!);
    DateTime startDate = DateTime(dateAux.year, dateAux.month, currentBill.monthlydueDay!);
    DateTime endDateAux =
        DateTime(dateAux.year, dateAux.month, 1).add(Duration(days: (28.5 * currentBill.ammountMonths!).round()));
    DateTime endDate = DateTime(endDateAux.year, endDateAux.month, currentBill.monthlydueDay!);

    return Scaffold(
      appBar: AppBar(title: Text(currentBill.name)),
      body: SafeArea(
        bottom: true,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            width: MediaQuery.of(context).size.width * .8,
            child: Column(
              children: [
                BillSummary(startDate: startDate, endDate: endDate, currentBill: currentBill),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => InstallmentCard(bill: currentBill, index: index + 1),
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemCount: currentBill.ammountMonths!,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BillSummary extends StatelessWidget {
  const BillSummary({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.currentBill,
  }) : super(key: key);

  final DateTime startDate;
  final DateTime endDate;
  final Bill currentBill;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              MultiLanguage.translate("start") + ": " + DateHelper.formatDDMMYYYY(startDate),
              style: TextStyles.bodyText(),
            ),
            Text(
              MultiLanguage.translate("end") + ": " + DateHelper.formatDDMMYYYY(endDate),
              style: TextStyles.bodyText(),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              MultiLanguage.translate("active") +
                  ": " +
                  MultiLanguage.translate(currentBill.isActive ?? false ? "yes" : "no"),
              style: TextStyles.bodyText(),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  MultiLanguage.translate("installment") + ": ",
                  style: TextStyles.bodyText(),
                ),
                const SizedBox(width: 2),
                const Icon(FontAwesomeIcons.brazilianRealSign, size: 14),
                Text(
                  " " + CurrencyHelper.formatDouble(currentBill.value),
                  style: TextStyles.bodyText(),
                ),
              ],
            ),
          ],
        ),
        if (currentBill.ammountMonths! > 0)
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                MultiLanguage.translate("numberOfInstallments") + ": ${currentBill.ammountMonths}",
                style: TextStyles.bodyText(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    MultiLanguage.translate("value") + " total: ",
                    style: TextStyles.bodyText(),
                  ),
                  const SizedBox(width: 2),
                  const Icon(FontAwesomeIcons.brazilianRealSign, size: 14),
                  Text(
                    " " + CurrencyHelper.formatDouble((currentBill.value! * currentBill.ammountMonths!)),
                    style: TextStyles.bodyText(),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
