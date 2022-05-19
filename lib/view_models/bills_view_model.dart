import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/models/bill.dart';

class BillsViewModel extends ChangeNotifier {
  bool _loading = false;
  List<Bill> _listBills = [];

  bool get loading => _loading;
  List<Bill> get listBills => _listBills;

  BillsViewModel() {
    getRegisteredBills();
  }

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  setListBills(List<Bill> listBills) => _listBills = listBills;

  getRegisteredBills() {
    setLoading(true);
    List<Bill> bills = [
      Bill(id: 4, title: "Faculdade", value: 580, monthlydueDate: DateTime.now().add(const Duration(days: 2))),
      Bill(id: 2, title: "Luz", value: 250.35874, monthlydueDate: DateTime.now().add(const Duration(days: 10))),
      Bill(id: 5, title: "Condomínio", value: 300, monthlydueDate: DateTime.now()),
      Bill(id: 3, title: "Internet", isPaid: true, value: 99, monthlydueDate: DateTime.now()),
      Bill(id: 1, title: "Aluguel", value: 900, monthlydueDate: DateTime.now().add(const Duration(days: 5))),
    ];
    bills.sort((a, b) => b.monthlydueDate!.compareTo(a.monthlydueDate!));
    bills.sort((a, b) => b.isPaid ? -1 : 1);
    setListBills(bills);
    setLoading(false);
  }
}
