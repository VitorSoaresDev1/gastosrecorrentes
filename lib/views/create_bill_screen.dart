import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastosrecorrentes/components/shared/button_with_loading.dart';
import 'package:gastosrecorrentes/services/multi_language.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:provider/provider.dart';

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen({Key? key}) : super(key: key);

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  late TextEditingController _nameController;
  late TextEditingController _valueController;
  late TextEditingController _dueDayController;
  late TextEditingController _amountMonthsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _valueController = TextEditingController();
    _dueDayController = TextEditingController();
    _amountMonthsController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _valueController.dispose();
    _dueDayController.dispose();
    _amountMonthsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final billsViewModel = context.watch<BillsViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(MultiLanguage.translate("createNewBill"))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CreateBillForm(
              nameController: _nameController,
              valueController: _valueController,
              dueDayController: _dueDayController,
              amountMonthsController: _amountMonthsController,
            ),
            const SizedBox(height: 32),
            ButtonWithLoading(
              isLoading: billsViewModel.loading,
              title: MultiLanguage.translate("createBill"),
              onPressed: () async => await billsViewModel.addNewBill(
                context,
                name: _nameController.text,
                value: _valueController.text,
                dueDay: _dueDayController.text,
                amountMonths: _amountMonthsController.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateBillForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController valueController;
  final TextEditingController dueDayController;
  final TextEditingController amountMonthsController;

  const CreateBillForm({
    Key? key,
    required this.nameController,
    required this.valueController,
    required this.dueDayController,
    required this.amountMonthsController,
  }) : super(key: key);

  final double? defaultFieldsVerticalPadding = 8;

  @override
  Widget build(BuildContext context) {
    final billsViewModel = context.watch<BillsViewModel>();
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
      child: Form(
        key: billsViewModel.createBillFormKey,
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

class CustomTextField extends StatelessWidget {
  final Widget title;
  final TextEditingController? controller;
  final TextInputAction? action;
  final TextInputType? type;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  const CustomTextField({
    Key? key,
    this.action,
    this.type,
    this.validator,
    this.controller,
    required this.title,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        title,
        Flexible(
          child: TextFormField(
            controller: controller,
            textInputAction: action,
            keyboardType: type,
            inputFormatters: inputFormatters,
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 4, bottom: 2),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}
