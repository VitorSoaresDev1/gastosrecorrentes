import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastosrecorrentes/helpers/currency_helper.dart';
import 'package:gastosrecorrentes/models/installment.dart';
import 'package:gastosrecorrentes/services/multi_language.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:gastosrecorrentes/view_models/users_view_model.dart';
import 'package:provider/provider.dart';

class ChangeValueButton extends StatelessWidget {
  final Installment installment;

  const ChangeValueButton({Key? key, required this.installment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billsViewModel = context.watch<BillsViewModel>();
    final usersViewModel = context.watch<UsersViewModel>();
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Tooltip(
          message: MultiLanguage.translate("changePrice"),
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: installment.isPaid ? null : () async => {},
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                elevation: 4,
                side: BorderSide(
                  width: 1,
                  color: installment.isPaid ? Colors.grey : Colors.white,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                textStyle: TextStyles.bodySubtitle(light: true),
              ),
              child: Center(
                  child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.brazilianRealSign,
                    size: 13,
                    color: Colors.grey[800],
                  ),
                  Text(
                    " ${CurrencyHelper.formatDouble(installment.price)}",
                    style: TextStyles.bodyText2(),
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
