import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gastosrecorrentes/models/create_bill_data.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/helpers/functions_helper.dart';
import 'package:gastosrecorrentes/services/remote/api_request.dart';
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
  Installment? currentSelectedInstallment;
  ApiRequest<List<Bill>> _listBills = ApiRequest.loading();

  BillsViewModel({required this.fireStoreService}) {
    fireStoreService = fireStoreService;
  }

  bool get loading => _loading;
  ApiRequest<List<Bill>> get listBills => _listBills;

  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  signedOut() {
    currentSelectedBill = null;
    currentSelectedInstallment = null;
    _listBills = ApiRequest.loading();
  }

  set setCurrentSelectedBill(Bill bill) => currentSelectedBill = bill;
  set setCurrentSelectedInstallment(Installment installment) => currentSelectedInstallment = installment;

  void setListBills(ApiRequest<List<Bill>> response) => _listBills = response;

  Installment getCurrentMonthInstallment(Bill bill) {
    DateTime now = DateTime.now();
    DateTime? duedate = DateTime(now.year, now.month, bill.monthlydueDay!);
    return bill.installments!.firstWhere((element) => element.dueDate == duedate, orElse: () => bill.installments![0]);
  }

  Future getRegisteredBills(String userId) async {
    try {
      setLoading(true);
      List<Bill> bills = await fireStoreService.getRegisteredBills(userId: userId);
      _removeInactiveBills(bills);

      await _updateInstallmentIsLateStatus(bills, userId);

      _addInstallmentsForOnGoingBills(bills);

      _sortBills(bills);

      setListBills(ApiRequest.completed(bills));
    } on FirebaseException catch (e) {
      setListBills(ApiRequest.error(e.code.toString()));
    } catch (e) {
      setListBills(ApiRequest.error(e.toString()));
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
          updated = true;
        }
      }
      if (updated) await fireStoreService.updateBill(bill);
      updated = false;
    }
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
            id: const Uuid().v1(),
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

  Future addNewBill({required BuildContext context, required CreateBillData data}) async {
    try {
      setLoading(true);
      DateTime startDate =
          DateTime(int.parse(data.startingMonth.split("/")[1]), int.parse(data.startingMonth.split("/")[0]), 1);
      double parsedValue = double.tryParse(data.value.replaceAll(",", ".")) ?? 0;

      Bill billToAdd = Bill(
        name: data.name.capitalizeFirst(),
        userId: data.userId,
        value: parsedValue,
        monthlydueDay: int.tryParse(data.dueDay) ?? 0,
        ammountMonths: int.tryParse(data.amountMonths),
        startDate: startDate.millisecondsSinceEpoch,
        installments: [],
        isActive: true,
      );

      billToAdd.installments = generateBillInstallments(billToAdd);

      await fireStoreService.addBill(billToAdd);
      await getRegisteredBills(data.userId);
      showSnackBar(MultiLanguage.translate("createdBillSuccessfully"));
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      showSnackBar(translateErrors(e.code));
    } catch (e) {
      showSnackBar(translateErrors(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  Future deleteBill(Bill bill, String userId, BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          context.watch<BillsViewModel>();
          return AlertDialog(
            content: Text(MultiLanguage.translate('confirmToDeleteBill')),
            actions: [
              TextButton(
                child: Text(MultiLanguage.translate('cancel')),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(MultiLanguage.translate('confirm')),
                onPressed: !loading
                    ? () async {
                        try {
                          setLoading(true);
                          await fireStoreService.deleteBill(bill);
                          await getRegisteredBills(userId);
                          setLoading(false);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } catch (e) {
                          showSnackBar(e.toString());
                        }
                      }
                    : null,
              ),
            ],
          );
        });
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
          id: const Uuid().v1(),
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

  Future updateCurrentAttachment(Installment installment, String? imageString) async {
    try {
      setLoading(true);
      for (Installment i in currentSelectedBill!.installments!) {
        if (i == installment) {
          i.attachment = imageString;
        }
      }
      await fireStoreService.updateBill(currentSelectedBill!);
      setLoading(false);
    } catch (e) {
      showSnackBar(e.toString());
    }
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
      showSnackBar(e.toString());
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
