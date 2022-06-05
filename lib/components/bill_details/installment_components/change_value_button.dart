import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastosrecorrentes/components/shared/confirm_button.dart';
import 'package:gastosrecorrentes/components/shared/custom_text_field.dart';
import 'package:gastosrecorrentes/helpers/currency_helper.dart';
import 'package:gastosrecorrentes/helpers/functions_helper.dart';
import 'package:gastosrecorrentes/models/installment.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:provider/provider.dart';

class ChangeValueButton extends StatefulWidget {
  final Installment installment;

  const ChangeValueButton({Key? key, required this.installment}) : super(key: key);

  @override
  State<ChangeValueButton> createState() => _ChangeValueButtonState();
}

class _ChangeValueButtonState extends State<ChangeValueButton> {
  final GlobalKey<FormState> validationKey = GlobalKey<FormState>();
  late TextEditingController valueController;

  @override
  void initState() {
    valueController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Tooltip(
          message: MultiLanguage.translate("changePrice"),
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: widget.installment.isPaid
                  ? null
                  : () async => showDialog(
                        context: context,
                        builder: (context) {
                          final billsViewModel = context.watch<BillsViewModel>();

                          return AlertDialog(
                            insetPadding: EdgeInsets.zero,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            shape: const BeveledRectangleBorder(),
                            alignment: Alignment.bottomCenter,
                            content: SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Form(
                                        key: validationKey,
                                        child: CustomTextField(
                                          controller: valueController,
                                          autoFocus: true,
                                          title: Text(MultiLanguage.translate("newValue") + ": "),
                                          type: const TextInputType.numberWithOptions(decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\,?\d{0,2}'))
                                          ],
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return MultiLanguage.translate("CANT_BE_EMPTY");
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  ConfirmButton(
                                    isLoading: billsViewModel.loading,
                                    onPressed: () async {
                                      if (validationKey.currentState!.validate()) {
                                        try {
                                          await billsViewModel.updateInstallmentPrice(
                                              widget.installment, valueController.text);
                                          Navigator.pop(context);
                                        } catch (e) {
                                          showSnackBar(context, e.toString());
                                        }
                                      }
                                    },
                                    child: const Center(
                                      child: Icon(FontAwesomeIcons.check),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                elevation: 4,
                side: BorderSide(
                  width: 1,
                  color: widget.installment.isPaid ? Colors.grey : Colors.white,
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
                      " ${CurrencyHelper.formatDouble(widget.installment.price)}",
                      style: TextStyles.bodyText2(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
