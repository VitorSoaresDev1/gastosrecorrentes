import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gastosrecorrentes/models/bill.dart';
import 'package:gastosrecorrentes/models/user.dart';
import 'package:gastosrecorrentes/shared/firestore_constants.dart';

class FireStoreService {
  static Future addUser({String name = '', String email = ''}) async {
    try {
      await FirebaseFirestore.instance
          .collection(FireStoreConstants.usersCollection)
          .add({"name": name, "email": email});
    } catch (e) {
      rethrow;
    }
  }

  static Future<AppUser> getUser({String email = ''}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection(FireStoreConstants.usersCollection)
          .where('email', isEqualTo: email.toLowerCase())
          .get();
      AppUser user = AppUser.fromMap(snapshot.docs[0].data());
      user.id = snapshot.docs[0].id;
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future addBill(Bill bill) async {
    try {
      await FirebaseFirestore.instance.collection(FireStoreConstants.billsCollection).add(bill.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future updateBill(Bill bill) async =>
      FirebaseFirestore.instance.collection(FireStoreConstants.billsCollection).doc(bill.id).update(bill.toMap());

  Future setBilltoInactive(Bill bill) async {
    FirebaseFirestore.instance
        .collection(FireStoreConstants.billsCollection)
        .doc(bill.id)
        .update(bill.copyWith(isActive: false).toMap());
  }

  Future<List<Bill>> getRegisteredBills({String? userId = ''}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection(FireStoreConstants.billsCollection)
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      List<Bill> bills = snapshot.docs.map((e) {
        Bill bill = Bill.fromMap(e.data());
        bill.id = e.id;
        return bill;
      }).toList();

      return bills;
    } catch (e) {
      rethrow;
    }
  }
}
