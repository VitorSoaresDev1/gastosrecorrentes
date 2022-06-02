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
import 'package:time_machine/time_machine.dart';

class BillDetailsScreen extends StatelessWidget {
  const BillDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billsViewModel = context.watch<BillsViewModel>();
    Bill currentBill = billsViewModel.currentSelectedBill!;

    return Scaffold(
      appBar: AppBar(title: Text(currentBill.name), elevation: 0),
      body: SafeArea(
        bottom: true,
        child: Center(
          child: Container(
            color: Colors.indigo,
            //padding: const EdgeInsets.only(bottom: 20),
            child: ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                const BillSummary(),
                const SizedBox(height: 8),
                Material(
                  elevation: 8,
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
                        itemBuilder: (context, index, animation) => InstallmentCard(
                          index: index,
                          installment: billsViewModel.currentBillInstallments?[index],
                          animation: animation,
                        ),
                        initialItemCount: billsViewModel.currentBillInstallments?.length ?? 0,
                      ),
                    ),
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
  const BillSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billsViewModel = context.watch<BillsViewModel>();
    Bill currentBill = billsViewModel.currentSelectedBill!;
    DateTime dateAux = DateTime.fromMillisecondsSinceEpoch(currentBill.startDate!);
    LocalDate startDate = LocalDate(dateAux.year, dateAux.month, currentBill.monthlydueDay!);
    LocalDate endDate = startDate.addMonths(currentBill.ammountMonths! - 1);
    double totalValue = (currentBill.value! * currentBill.ammountMonths!);
    double paidSoFar = (currentBill.payments.entries.length * currentBill.value!);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                MultiLanguage.translate("start") + ": " + DateHelper.formatDDMMYYYY(startDate),
                style: TextStyles.bodyText(light: true),
              ),
              if (currentBill.ammountMonths! > 0)
                Text(
                  MultiLanguage.translate("end") + ": " + DateHelper.formatDDMMYYYY(endDate),
                  style: TextStyles.bodyText(light: true),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    MultiLanguage.translate("active") +
                        ": " +
                        MultiLanguage.translate(currentBill.isActive ?? false ? "yes" : "no"),
                    style: TextStyles.bodyText(light: true),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    MultiLanguage.translate("value") + ": ",
                    style: TextStyles.bodyText(light: true),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    FontAwesomeIcons.brazilianRealSign,
                    size: 14,
                    color: Colors.white,
                  ),
                  Text(
                    " " + CurrencyHelper.formatDouble(currentBill.value),
                    style: TextStyles.bodyText(light: true),
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
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      MultiLanguage.translate("installments") +
                          ": ${currentBill.payments.entries.length} / ${currentBill.ammountMonths}",
                      style: TextStyles.bodyText(light: true),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(FontAwesomeIcons.brazilianRealSign, size: 14, color: Colors.white),
                        Text(
                          " " + CurrencyHelper.formatDouble(paidSoFar),
                          style: TextStyles.bodyText(light: true),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          MultiLanguage.translate("total") + ": ",
                          style: TextStyles.bodyText(light: true),
                        ),
                        const SizedBox(width: 2),
                        const Icon(FontAwesomeIcons.brazilianRealSign, size: 14, color: Colors.white),
                        Text(
                          " ${CurrencyHelper.formatDouble(totalValue)}",
                          style: TextStyles.bodyText(light: true),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          MultiLanguage.translate("remaining") + ": ",
                          style: TextStyles.bodyText(light: true),
                        ),
                        const SizedBox(width: 2),
                        const Icon(FontAwesomeIcons.brazilianRealSign, size: 14, color: Colors.white),
                        Text(
                          " " + CurrencyHelper.formatDouble(totalValue - paidSoFar),
                          style: TextStyles.bodyText(light: true),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
        ],
      ),
    );
  }
}
