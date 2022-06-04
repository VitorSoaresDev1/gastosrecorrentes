import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/helpers/functions_helper.dart';
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

  // void generateCurrentBillInstallments() {
  //   if (currentSelectedBill == null) return;
  //   DateTime dateAux = DateTime.fromMillisecondsSinceEpoch(currentSelectedBill!.startDate!);
  //   LocalDate start = LocalDate(dateAux.year, dateAux.month, currentSelectedBill!.monthlydueDay!);
  //   Period diff = LocalDate.today().periodSince(start);

  //   int numberOfInstallments =
  //       (currentSelectedBill!.ammountMonths! == 0) ? diff.months + 1 : currentSelectedBill!.ammountMonths!;
  //   List<Installment> installments = [];
  //   for (int x = 0; x < numberOfInstallments; x++) {
  //     LocalDate dueDate = LocalDate(dateAux.year, dateAux.month, currentSelectedBill!.monthlydueDay!).addMonths(x);
  //     bool isPaid = currentSelectedBill!.payments.containsKey(dueDate.toDateTimeUnspecified().toString());
  //     bool isLate = dueDate.compareTo(LocalDate.today()) < 0 && !isPaid;
  //     installments.add(
  //       Installment(
  //         index: x + 1,
  //         dueDate: dueDate.toDateTimeUnspecified(),
  //         price: currentSelectedBill!.value!,
  //         isLate: isLate,
  //         isPaid: isPaid,
  //       ),
  //     );
  //   }
  //   installments.sort((a, b) {
  //     if (a.isPaid == b.isPaid) {
  //       return a.dueDate.compareTo(b.dueDate);
  //     } else {
  //       return b.isPaid ? -1 : 1;
  //     }
  //   });
  //   currentBillInstallments = installments;
  // }

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

      addInstallmentsForOnGoingBills(bills);

      sortBills(bills);

      setListBills(bills);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  void addInstallmentsForOnGoingBills(List<Bill> bills) {
    bills.where((bill) => bill.ammountMonths == 0).toList().forEach((bill) {
      DateTime now = DateTime.now();
      DateTime currentMonthInstallment = DateTime(now.year, now.month, bill.monthlydueDay!);
      if (bill.installments!.where((element) => element.dueDate == currentMonthInstallment).isEmpty) {
        bool isLate = currentMonthInstallment.compareTo(DateTime.now()) < 0;
        bill.installments!.add(
          Installment(
            index: bill.installments!.length,
            dueDate: currentMonthInstallment,
            price: bill.value!,
            isLate: isLate,
            isPaid: false,
          ),
        );
        bill.installments!.sort((a, b) => paidsLastThenByDate(a, b));
        fireStoreService.updateBill(bill);
      }
    });
  }

  void sortBills(List<Bill> bills) {
    DateTime now = DateTime.now();
    bills.sort((a, b) {
      DateTime aMonthInstallment = DateTime(now.year, now.month, a.monthlydueDay!);
      DateTime bMonthInstallment = DateTime(now.year, now.month, b.monthlydueDay!);
      bool aIsPaid =
          a.installments!.where((element) => element.dueDate == aMonthInstallment && element.isPaid).isNotEmpty;
      bool bIsPaid =
          b.installments!.where((element) => element.dueDate == bMonthInstallment && element.isPaid).isNotEmpty;
      if (aIsPaid == bIsPaid) {
        return b.monthlydueDay!.compareTo(a.monthlydueDay!);
      } else {
        return bIsPaid ? -1 : 1;
      }
    });
  }

  Future addNewBill({
    required String name,
    required String value,
    required String dueDay,
    required String amountMonths,
    required String userId,
  }) async {
    try {
      setLoading(true);
      DateTime now = DateTime.now();
      DateTime startDate = DateTime(now.year, now.month, 1).subtract(const Duration(days: 120));
      double parsedValue = double.tryParse(value.replaceAll(",", ".")) ?? 0;

      Bill billToAdd = Bill(
        name: name.capitalizeFirst(),
        userId: userId,
        value: parsedValue,
        monthlydueDay: int.tryParse(dueDay) ?? 0,
        ammountMonths: int.tryParse(amountMonths),
        startDate: startDate.millisecondsSinceEpoch,
        installments: [],
        isActive: true,
      );

      billToAdd.installments = generateBillInstallments(billToAdd);

      await fireStoreService.addBill(billToAdd);
      await getRegisteredBills(userId);
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  List<Installment> generateBillInstallments(Bill bill) {
    DateTime dateAux = DateTime.fromMillisecondsSinceEpoch(bill.startDate!);
    LocalDate start = LocalDate(dateAux.year, dateAux.month, bill.monthlydueDay!);
    Period diff = LocalDate.today().periodSince(start);

    int infiniteInstallmentsAmountToCreate = diff.months == 0 ? 1 : diff.months + 2;
    int numberOfInstallments = (bill.ammountMonths! == 0) ? infiniteInstallmentsAmountToCreate : bill.ammountMonths!;
    List<Installment> installments = [];
    for (int x = 0; x < numberOfInstallments; x++) {
      LocalDate dueDate = LocalDate(dateAux.year, dateAux.month, bill.monthlydueDay!).addMonths(x);
      bool isLate = dueDate.compareTo(LocalDate.today()) < 0;
      installments.add(
        Installment(
          index: x + 1,
          dueDate: dueDate.toDateTimeUnspecified(),
          price: bill.value!,
          isLate: isLate,
          isPaid: false,
        ),
      );
    }
    installments.sort((a, b) => paidsLastThenByDate(a, b));
    return installments;
  }

  Future payInstallmentDialog(BuildContext context, InstallmentCard installmentCard, String userId) async {
    return showDialog(context: context, builder: (context) => const PayInstallmentDialog()).then((value) async {
      if (value) {
        animatedListKey.currentState?.removeItem(
          installmentCard.index,
          (context, animation) => InstallmentCard(
            animation: animation,
            index: installmentCard.index,
            installment: installmentCard.installment,
          ),
          duration: const Duration(milliseconds: 500),
        );
        try {
          await payInstallment(installmentCard.installment!, userId);
          animatedListKey.currentState?.insertItem(
            (currentSelectedBill?.installments!.length ?? 0) - 1,
          );
        } catch (e) {
          animatedListKey.currentState?.insertItem(
            installmentCard.index,
          );
          showSnackBar(context, e.toString());
        }
      }
    });
  }

  Future payInstallment(Installment installment, String userId) async {
    setLoading(true);
    Bill bill = currentSelectedBill!;
    try {
      int index = bill.installments!.indexOf(installment);
      if (index >= 0) {
        bill.installments![index].isPaid = true;
        bill.installments!.sort((a, b) => paidsLastThenByDate(a, b));
        await fireStoreService.updateBill(bill);
      }
    } catch (e) {
      int index = bill.installments!.indexOf(installment);
      bill.installments![index].isPaid = false;
      bill.installments!.sort((a, b) => paidsLastThenByDate(a, b));
      rethrow;
    } finally {
      await getRegisteredBills(userId);
      setLoading(false);
    }
  }

  int paidsLastThenByDate(a, b) {
    if (a.isPaid == b.isPaid) {
      return a.dueDate.compareTo(b.dueDate);
    } else {
      return b.isPaid ? -1 : 1;
    }
  }
}
