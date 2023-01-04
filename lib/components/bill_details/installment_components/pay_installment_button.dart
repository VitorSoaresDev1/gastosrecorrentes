import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastosrecorrentes/components/bill_details/installment_components/installment_card.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:gastosrecorrentes/view_models/users_view_model.dart';
import 'package:provider/provider.dart';

class PayInstallmentButton extends StatelessWidget {
  final InstallmentCard installmentCard;

  const PayInstallmentButton({
    Key? key,
    required this.installmentCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BillsViewModel billsViewModel = context.watch<BillsViewModel>();
    final UsersViewModel usersViewModel = context.watch<UsersViewModel>();
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Tooltip(
        message: MultiLanguage.translate("informPayment"),
        child: SizedBox(
          height: 40,
          width: 50,
          child: ElevatedButton(
            onPressed: installmentCard.installment.isPaid
                ? null
                : () async => await billsViewModel.payInstallment(
                      context,
                      installmentCard,
                      usersViewModel.user!.id!,
                    ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              foregroundColor: Colors.green[800],
              elevation: 4,
              side: BorderSide(
                width: 1,
                color: installmentCard.installment.isPaid ? Colors.grey : Colors.green[800]!,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: TextStyles.bodySubtitle(light: true),
            ),
            child: const Center(
              child: Icon(FontAwesomeIcons.check, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
