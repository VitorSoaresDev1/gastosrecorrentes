import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastosrecorrentes/components/shared/custom_text_field.dart';
import 'package:gastosrecorrentes/helpers/date_helper.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/view_models/init_app_view_model.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';

class CreateBillForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController valueController;
  final TextEditingController dueDayController;
  final TextEditingController startMonthController;
  final TextEditingController amountMonthsController;
  final GlobalKey<FormState> createBillFormKey;
  final DateTime selectedDate = DateTime.now();
  CreateBillForm({
    Key? key,
    required this.nameController,
    required this.valueController,
    required this.dueDayController,
    required this.amountMonthsController,
    required this.createBillFormKey,
    required this.startMonthController,
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
            SizedBox(height: defaultFieldsVerticalPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: startMonthController,
                    onTap: () async => _openMonthPickerDialog(context),
                    readOnly: true,
                    title: Text(MultiLanguage.translate("startingMonth") + ": "),
                    type: const TextInputType.numberWithOptions(signed: true, decimal: true),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return MultiLanguage.translate("CANT_BE_EMPTY");
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async => _openMonthPickerDialog(context),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _openMonthPickerDialog(BuildContext context) => showMonthPicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 1, 5),
        lastDate: DateTime(DateTime.now().year + 1, 9),
        initialDate: selectedDate,
        locale: Locale(Provider.of<InitAppViewModel>(context, listen: false).language),
      ).then((date) {
        if (date != null) {
          startMonthController.text = DateHelper.formatMMYYYY(LocalDate.dateTime(date), context);
        }
      });
}
