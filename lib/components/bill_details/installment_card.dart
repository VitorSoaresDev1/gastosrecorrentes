import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastosrecorrentes/helpers/date_helper.dart';
import 'package:gastosrecorrentes/models/installment.dart';
import 'package:gastosrecorrentes/services/multi_language.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:gastosrecorrentes/view_models/users_view_model.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';

class InstallmentCard extends StatelessWidget {
  final int index;
  final Installment? installment;
  final VoidCallback? onTap;
  final Animation<double> animation;
  const InstallmentCard({Key? key, this.onTap, this.installment, required this.animation, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billsViewModel = context.watch<BillsViewModel>();
    final usersViewModel = context.watch<UsersViewModel>();
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
              border: Border.all(width: 1, color: Installment.getInstallmentColor(context, installment!)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: installment != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(MultiLanguage.translate("installment") + ": ${installment?.index}",
                                      style: TextStyles.bodySubtitle()),
                                  Text(
                                    "${MultiLanguage.translate("dueTo")}: " +
                                        DateHelper.formatDDMMYYYY(LocalDate.dateTime(installment!.dueDate)),
                                    style: TextStyles.bodySubtitle(),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: SizedBox(
                                    height: 35,
                                    width: 200,
                                    child: ElevatedButton(
                                      onPressed: installment!.isPaid
                                          ? null
                                          : () async => await billsViewModel.payInstallmentDialog(
                                              context, this, usersViewModel.user!.id!),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green[800],
                                        elevation: 6,
                                        side: BorderSide(
                                            width: 1, color: installment!.isPaid ? Colors.grey : Colors.green[900]!),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                        textStyle: TextStyles.bodySubtitle(light: true),
                                      ),
                                      child: Center(
                                          child: Text("Informar Pagamento", style: TextStyles.bodyText2(light: true))),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Text("unknow error", style: TextStyles.bodySubtitle()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
