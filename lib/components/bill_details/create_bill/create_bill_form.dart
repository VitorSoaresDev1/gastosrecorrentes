import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastosrecorrentes/components/shared/custom_text_field.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';

class CreateBillForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController valueController;
  final TextEditingController dueDayController;
  final TextEditingController amountMonthsController;
  final GlobalKey<FormState> createBillFormKey;

  const CreateBillForm({
    Key? key,
    required this.nameController,
    required this.valueController,
    required this.dueDayController,
    required this.amountMonthsController,
    required this.createBillFormKey,
  }) : super(key: key);

  final double? defaultFieldsVerticalPadding = 8;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
      child: Form(
        key: createBillFormKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextField(
              controller: nameController,
              title: Text(MultiLanguage.translate("name") + ": "),
              action: TextInputAction.next,
              type: TextInputType.name,
              validator: (val) {
                if (val!.isEmpty) {
                  return MultiLanguage.translate("ENTER_VALID_NAME");
                }
                return null;
              },
            ),
            SizedBox(height: defaultFieldsVerticalPadding),
            CustomTextField(
              controller: valueController,
              title: Text(MultiLanguage.translate("value") + ": "),
              action: TextInputAction.next,
              type: const TextInputType.numberWithOptions(signed: true, decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\,?\d{0,2}'))],
              validator: (val) {
                if (val!.isEmpty) {
                  return MultiLanguage.translate("CANT_BE_EMPTY");
                }
                return null;
              },
            ),
            SizedBox(height: defaultFieldsVerticalPadding),
            CustomTextField(
              controller: dueDayController,
              title: Text(MultiLanguage.translate("dueDay") + ": "),
              action: TextInputAction.next,
              type: const TextInputType.numberWithOptions(signed: true, decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}'))],
              validator: (val) {
                int value = int.tryParse(val!) ?? 0;
                if (val.isEmpty) {
                  return MultiLanguage.translate("CANT_BE_EMPTY");
                }
                if (value < 1 || value > 31) {
                  return MultiLanguage.translate("INVALID_DAY_OF_MONTH");
                }
                return null;
              },
            ),
            SizedBox(height: defaultFieldsVerticalPadding),
            CustomTextField(
              controller: amountMonthsController,
              title: Row(
                children: [
                  Tooltip(
                      message: MultiLanguage.translate("numberOfInstallmentsExplainText"),
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.help_outline, size: 16, color: Colors.blue)),
                  const SizedBox(width: 2),
                  Text(MultiLanguage.translate("numberOfInstallments")),
                  const Text(": "),
                ],
              ),
              action: TextInputAction.done,
              type: const TextInputType.numberWithOptions(signed: true, decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}'))],
              validator: (val) {
                if (val!.isEmpty) {
                  return MultiLanguage.translate("CANT_BE_EMPTY");
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
