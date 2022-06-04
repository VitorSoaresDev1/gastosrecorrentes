import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/helpers/date_helper.dart';
import 'package:gastosrecorrentes/models/installment.dart';
import 'package:gastosrecorrentes/services/multi_language.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';
import 'package:time_machine/time_machine.dart';

class InstallmentSummary extends StatelessWidget {
  final Installment installment;

  const InstallmentSummary({Key? key, required this.installment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${MultiLanguage.translate("installment")}: ${installment.index}.",
          style: TextStyles.bodyText2(),
        ),
        Text(
          "${MultiLanguage.translate("dueTo")}: " + DateHelper.formatDDMMYYYY(LocalDate.dateTime(installment.dueDate)),
          style: TextStyles.bodyText2(),
        ),
      ],
    );
  }
}
