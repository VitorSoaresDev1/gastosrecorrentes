import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';

import 'package:gastosrecorrentes/components/bill_details/installment_card.dart';
import 'package:gastosrecorrentes/components/dialogs/pay_installment_dialog.dart';
import 'package:gastosrecorrentes/helpers/string_extensions.dart';
import 'package:gastosrecorrentes/models/bill.dart';
import 'package:gastosrecorrentes/models/installment.dart';
import 'package:gastosrecorrentes/services/firestore_service.dart';

class BillsViewModel extends ChangeNotifier {
  final GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  FireStoreService fireStoreService;
  bool _loading = false;
  List<Bill> _listBills = [];
  Bill? currentSelectedBill;
  List<Installment>? currentBillInstallments;

  BillsViewModel({
    required this.fireStoreService,
  }) {
    fireStoreService = fireStoreService;
  }

  bool get loading => _loading;
  List<Bill> get listBills => _listBills;

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  set setCurrentSelectedBill(Bill bill) => currentSelectedBill = bill;

  void setListBills(List<Bill> listBills) => _listBills = listBills;

  void generateCurrentBillInstallments() {
    if (currentSelectedBill == null) return;
    DateTime dateAux = DateTime.fromMillisecondsSinceEpoch(currentSelectedBill!.startDate!);
    LocalDate start = LocalDate(dateAux.year, dateAux.month, currentSelectedBill!.monthlydueDay!);
    Period diff = LocalDate.today().periodSince(start);

    int numberOfInstallments =
        (currentSelectedBill!.ammountMonths! == 0) ? diff.months + 1 : currentSelectedBill!.ammountMonths!;
    List<Installment> installments = [];
    for (int x = 0; x < numberOfInstallments; x++) {
      LocalDate dueDate = LocalDate(dateAux.year, dateAux.month, currentSelectedBill!.monthlydueDay!).addMonths(x);
      bool isPaid = currentSelectedBill!.payments.containsKey(dueDate.toDateTimeUnspecified().toString());
      bool isLate = dueDate.compareTo(LocalDate.today()) < 0 && !isPaid;
      installments.add(
        Installment(
          index: x + 1,
          dueDate: dueDate.toDateTimeUnspecified(),
          price: currentSelectedBill!.value!,
          isLate: isLate,
          isPaid: isPaid,
        ),
      );
    }
    installments.sort((a, b) {
      if (a.isPaid == b.isPaid) {
        return a.dueDate.compareTo(b.dueDate);
      } else {
        return b.isPaid ? -1 : 1;
      }
    });
    currentBillInstallments = installments;
  }

  Future getRegisteredBills(String userId) async {
    try {
      setLoading(true);
      List<Bill> bills = await fireStoreService.getRegisteredBills(userId: userId);
      bills.removeWhere((bill) {
        DateTime dateAux = DateTime.fromMillisecondsSinceEpoch(bill.startDate!);
        LocalDate start = LocalDate(dateAux.year, dateAux.month, bill.monthlydueDay!);
        Period diff = LocalDate.today().periodSince(start);
        int monthsPassed = diff.months;
        if (monthsPassed > bill.ammountMonths! && bill.ammountMonths != 0) {
          fireStoreService.setBilltoInactive(bill);
          return true;
        }
        return false;
      });

      bills.sort((a, b) => b.monthlydueDay!.compareTo(a.monthlydueDay!));
      //TODO Ordernar pagos esse mês.
      setListBills(bills);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future addNewBill({
    String name = '',
    String value = '0',
    String dueDay = '0',
    String amountMonths = '0',
    String userId = '',
  }) async {
    try {
      setLoading(true);
      double parsedValue = double.tryParse(value.replaceAll(",", ".")) ?? 0;
      int parsedDueDay = int.tryParse(dueDay) ?? 0;
      int? parsedAmountMonths = int.tryParse(amountMonths);
      await fireStoreService.addBill(
        name: name.capitalizeFirst(),
        userId: userId,
        value: parsedValue,
        dueDay: parsedDueDay,
        ammountMonths: parsedAmountMonths,
      );
      await getRegisteredBills(userId);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future payInstallmentDialog(BuildContext context, InstallmentCard installmentCard, String userId) async {
    return showDialog(context: context, builder: (context) => const PayInstallmentDialog()).then((value) async {
      if (value) {
        await payInstallment(installmentCard.installment!, userId);
        animatedListKey.currentState?.removeItem(
          installmentCard.index,
          (context, animation) => InstallmentCard(
            animation: animation,
            index: installmentCard.index,
            installment: installmentCard.installment,
          ),
        );
        animatedListKey.currentState?.insertItem(
          currentBillInstallments!.length - 1,
        );
      }
    });
  }

  Future payInstallment(Installment installment, String userId) async {
    setLoading(true);
    Bill bill = currentSelectedBill!;
    bill.payments.putIfAbsent(installment.dueDate.toString(), () => true);
    await fireStoreService.updateBill(bill);
    await getRegisteredBills(userId);
    setCurrentSelectedBill = bill;
    setLoading(false);
  }
}
