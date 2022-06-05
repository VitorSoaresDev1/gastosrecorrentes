import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastosrecorrentes/helpers/currency_helper.dart';
import 'package:gastosrecorrentes/helpers/date_helper.dart';
import 'package:gastosrecorrentes/models/bill.dart';
import 'package:gastosrecorrentes/models/installment.dart';
import 'package:gastosrecorrentes/services/multi_language.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';

class BillSummary extends StatelessWidget {
  const BillSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billsViewModel = context.watch<BillsViewModel>();
    Bill currentBill = billsViewModel.currentSelectedBill!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dateTile(currentBill),
          const SizedBox(height: 8),
          _activeAndDefaultValueTile(currentBill),
          const SizedBox(height: 16),
          _pricesTiles(currentBill),
        ],
      ),
    );
  }

  Row _dateTile(Bill currentBill) {
    DateTime dateAux = DateTime.fromMillisecondsSinceEpoch(currentBill.startDate!);
    LocalDate startDate = LocalDate(dateAux.year, dateAux.month, currentBill.monthlydueDay!);
    LocalDate endDate = startDate.addMonths(currentBill.ammountMonths! - 1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          MultiLanguage.translate("start") + ": " + DateHelper.formatMMYY(startDate),
          style: TextStyles.bodyText(light: true),
        ),
        if (currentBill.ammountMonths! > 0)
          Text(
            MultiLanguage.translate("end") + ": " + DateHelper.formatMMYY(endDate),
            style: TextStyles.bodyText(light: true),
          ),
      ],
    );
  }

  Row _activeAndDefaultValueTile(Bill currentBill) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              MultiLanguage.translate("active") + ": ",
              style: TextStyles.bodyText(light: true),
            ),
            Icon(
              (currentBill.isActive ?? false) ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
              color: Colors.white,
              size: 16,
            )
          ],
        ),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Text(
        //       MultiLanguage.translate("value") + ": ",
        //       style: TextStyles.bodyText(light: true),
        //     ),
        //     const SizedBox(width: 2),
        //     const Icon(
        //       FontAwesomeIcons.brazilianRealSign,
        //       size: 14,
        //       color: Colors.white,
        //     ),
        //     Text(
        //       " " + CurrencyHelper.formatDouble(currentBill.value),
        //       style: TextStyles.bodyText(light: true),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _pricesTiles(Bill currentBill) {
    double totalValue = extractTotalPriceFrom(currentBill.installments!);
    List<Installment> installmentsPaid = currentBill.installments!.where((installment) => installment.isPaid).toList();
    double paidSoFar = extractTotalPriceFrom(installmentsPaid);

    return Column(
      children: [
        _paidSoFarTile(installmentsPaid, currentBill, paidSoFar),
        const SizedBox(height: 8),
        if (currentBill.ammountMonths! > 0) _totalAndRemainingTile(totalValue, installmentsPaid, paidSoFar),
      ],
    );
  }

  double extractTotalPriceFrom(List<Installment> installmentsPaid) {
    if (installmentsPaid.isEmpty) return 0;
    return installmentsPaid.map((i) => i.price).reduce((value, price) => value + price);
  }

  Row _paidSoFarTile(List<Installment> installmentsPaid, Bill currentBill, double paidSoFar) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          MultiLanguage.translate("installments") +
              ": ${installmentsPaid.length} / ${currentBill.installments!.length}",
          style: TextStyles.bodyText(light: true),
        ),
        if (installmentsPaid.isNotEmpty)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                MultiLanguage.translate("paid") + ": ",
                style: TextStyles.bodyText(light: true),
              ),
              const Icon(FontAwesomeIcons.brazilianRealSign, size: 14, color: Colors.white),
              Text(
                " " + CurrencyHelper.formatDouble(paidSoFar),
                style: TextStyles.bodyText(light: true),
              ),
            ],
          ),
      ],
    );
  }

  Widget _totalAndRemainingTile(double totalValue, List<Installment> installmentsPaid, double paidSoFar) {
    return Row(
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
        if (installmentsPaid.isNotEmpty)
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
    );
  }
}
