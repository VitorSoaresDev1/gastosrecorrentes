import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/components/bill_details/create_bill/create_bill_form.dart';
import 'package:gastosrecorrentes/components/shared/button_with_loading.dart';
import 'package:gastosrecorrentes/models/create_bill_data.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:gastosrecorrentes/view_models/users_view_model.dart';
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
  final GlobalKey<FormState> createBillFormKey = GlobalKey<FormState>();

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
    final usersViewModel = context.watch<UsersViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text(MultiLanguage.translate("createNewBill"))),
      bottomNavigationBar: Container(
        height: kBottomNavigationBarHeight,
        color: Colors.grey[50],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CreateBillForm(
              createBillFormKey: createBillFormKey,
              nameController: _nameController,
              valueController: _valueController,
              dueDayController: _dueDayController,
              amountMonthsController: _amountMonthsController,
            ),
            const SizedBox(height: 32),
            ButtonWithLoading(
              isLoading: billsViewModel.loading,
              title: MultiLanguage.translate("createBill"),
              onPressed: !billsViewModel.loading
                  ? () async {
                      if (createBillFormKey.currentState!.validate()) {
                        CreateBillData data = CreateBillData(
                          userId: usersViewModel.user!.id!,
                          name: _nameController.text,
                          value: _valueController.text,
                          dueDay: _dueDayController.text,
                          amountMonths: _amountMonthsController.text,
                        );
                        await billsViewModel.addNewBill(context: context, data: data);
                      }
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
