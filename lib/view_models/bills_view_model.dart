import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/helpers/functions_helper.dart';
import 'package:gastosrecorrentes/services/remote/api_response.dart';
import 'package:time_machine/time_machine.dart';

import 'package:gastosrecorrentes/components/bill_details/installment_components/installment_card.dart';
import 'package:gastosrecorrentes/helpers/string_extensions.dart';
import 'package:gastosrecorrentes/models/bill.dart';
import 'package:gastosrecorrentes/models/installment.dart';
import 'package:gastosrecorrentes/services/remote/firestore_service.dart';

class BillsViewModel extends ChangeNotifier {
  final GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  FireStoreService fireStoreService;
  bool _loading = false;
  Bill? currentSelectedBill;
  ApiResponse<List<Bill>> _listBills = ApiResponse.loading();

  BillsViewModel({required this.fireStoreService}) {
    fireStoreService = fireStoreService;
  }

  bool get loading => _loading;
  ApiResponse<List<Bill>> get listBills => _listBills;

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  set setCurrentSelectedBill(Bill bill) => currentSelectedBill = bill;

  void setListBills(ApiResponse<List<Bill>> response) => _listBills = response;

  Future getRegisteredBills(String userId) async {
    try {
      setLoading(true);
      List<Bill> bills = await fireStoreService.getRegisteredBills(userId: userId);
      _removeInactiveBills(bills);

      await _updateInstallmentIsLateStatus(bills, userId);

      _addInstallmentsForOnGoingBills(bills);

      _sortBills(bills);

      setListBills(ApiResponse.completed(bills));
    } catch (e) {
      setListBills(ApiResponse.error(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  Future<void> _updateInstallmentIsLateStatus(List<Bill> bills, String userId) async {
    bool updated = false;
    for (Bill bill in bills) {
      for (Installment installment in bill.installments!) {
        if (installment.dueDate.compareTo(DateTime.now()) < 0 && !installment.isLate) {
          installment.isLate = true;
          await fireStoreService.updateBill(bill);
          updated = true;
        }
      }
    }
    if (updated) await getRegisteredBills(userId);
  }

  void _removeInactiveBills(List<Bill> bills) {
    return bills.removeWhere((bill) {
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
  }

  void _addInstallmentsForOnGoingBills(List<Bill> bills) {
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

  void _sortBills(List<Bill> bills) {
    DateTime now = DateTime.now();
    bills.sort((a, b) {
      DateTime aMonthInstallment = DateTime(now.year, now.month, a.monthlydueDay!);
      DateTime bMonthInstallment = DateTime(now.year, now.month, b.monthlydueDay!);
      bool aIsPaid =
          a.installments!.where((element) => element.dueDate == aMonthInstallment && element.isPaid).isNotEmpty;
      bool bIsPaid =
          b.installments!.where((element) => element.dueDate == bMonthInstallment && element.isPaid).isNotEmpty;

      if (aIsPaid == bIsPaid) {
        return a.installments![0].dueDate.compareTo(b.installments![0].dueDate);
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

  Future updateInstallmentPrice(Installment installment, String value) async {
    double parsedValue = double.tryParse(value.replaceAll(",", ".")) ?? 0;
    setLoading(true);
    for (Installment i in currentSelectedBill!.installments!) {
      if (i == installment) {
        i.price = parsedValue;
      }
    }
    await fireStoreService.updateBill(currentSelectedBill!);
    setLoading(false);
  }

  Future payInstallment(BuildContext context, InstallmentCard installmentCard, String userId) async {
    setLoading(true);
    Bill bill = currentSelectedBill!;
    try {
      int index = bill.installments!.indexOf(installmentCard.installment);
      if (index >= 0) {
        animatedListKey.currentState?.removeItem(
          installmentCard.index,
          (context, animation) => InstallmentCard(
            animation: animation,
            index: installmentCard.index,
            installment: installmentCard.installment,
          ),
          duration: const Duration(milliseconds: 500),
        );
        bill.installments![index].isPaid = true;
        bill.installments!.sort((a, b) => paidsLastThenByDate(a, b));
        await fireStoreService.updateBill(bill);

        animatedListKey.currentState?.insertItem(
          (currentSelectedBill?.installments!.length ?? 0) - 1,
        );
      }
    } catch (e) {
      int index = bill.installments!.indexOf(installmentCard.installment);
      bill.installments![index].isPaid = false;
      bill.installments!.sort((a, b) => paidsLastThenByDate(a, b));
      showSnackBar(context, e.toString());
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
