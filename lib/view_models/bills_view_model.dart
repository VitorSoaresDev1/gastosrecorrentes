import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/helpers/functions_helper.dart';
import 'package:gastosrecorrentes/helpers/string_extensions.dart';
import 'package:gastosrecorrentes/models/bill.dart';
import 'package:gastosrecorrentes/services/firestore_service.dart';
import 'package:gastosrecorrentes/services/multi_language.dart';
import 'package:gastosrecorrentes/view_models/users_view_model.dart';
import 'package:provider/provider.dart';

class BillsViewModel extends ChangeNotifier {
  final GlobalKey<FormState> createBillFormKey = GlobalKey<FormState>();

  bool _loading = false;
  List<Bill> _listBills = [];
  Bill? currentSelectedBill;

  bool get loading => _loading;
  List<Bill> get listBills => _listBills;

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  set setCurrentSelectedBill(Bill value) => currentSelectedBill = value;

  void setListBills(List<Bill> listBills) => _listBills = listBills;

  Future getRegisteredBills(BuildContext context) async {
    final usersViewModel = Provider.of<UsersViewModel>(context, listen: false);
    try {
      setLoading(true);
      List<Bill> bills = await FireStoreService.getRegisteredBills(userId: usersViewModel.user?.id);
      bills.removeWhere((bill) {
        DateTime started = DateTime.fromMillisecondsSinceEpoch(bill.startDate!);
        Duration duration = DateTime.now().difference(started);
        int monthsPassed = duration.inDays ~/ 30;
        if (monthsPassed > bill.ammountMonths! && bill.ammountMonths != 0) {
          FireStoreService.setBilltoInactive(bill);
          return true;
        }
        return false;
      });

      bills.sort((a, b) => b.monthlydueDay!.compareTo(a.monthlydueDay!));
      bills.sort((a, b) => (b.isPaid?[0] == true) ? -1 : 1);
      setListBills(bills);
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future addNewBill(BuildContext context,
      {String name = '', String value = '0', String dueDay = '0', String amountMonths = '0'}) async {
    final usersViewModel = Provider.of<UsersViewModel>(context, listen: false);
    if (createBillFormKey.currentState!.validate()) {
      try {
        setLoading(true);
        String userId = usersViewModel.user?.id ?? '';
        double parsedValue = double.tryParse(value.replaceAll(",", ".")) ?? 0;
        int parsedDueDay = int.tryParse(dueDay) ?? 0;
        int? parsedAmountMonths = int.tryParse(amountMonths);
        await FireStoreService.addBill(
          name: name.capitalizeFirst(),
          userId: userId,
          value: parsedValue,
          dueDay: parsedDueDay,
          ammountMonths: parsedAmountMonths,
        );
        showSnackBar(context, MultiLanguage.translate("createdBillSuccessfully"));
        await getRegisteredBills(context);
        Navigator.pop(context);
      } catch (e) {
        showSnackBar(context, e.toString());
      } finally {
        setLoading(false);
      }
    }
  }
}
