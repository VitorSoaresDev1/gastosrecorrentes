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

  static Future addBill({
    String name = '',
    String? userId,
    double? value,
    int? dueDay,
    int? ammountMonths,
  }) async {
    try {
      await FirebaseFirestore.instance.collection(FireStoreConstants.billsCollection).add({
        "name": name,
        "userId": userId,
        "value": value,
        "monthlydueDay": dueDay,
        "ammountMonths": ammountMonths,
        "startDate": DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Bill>> getRegisteredBills({String? userId = ''}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection(FireStoreConstants.billsCollection)
          .where('userId', isEqualTo: userId)
          .get();
      List<Bill> bills = snapshot.docs.map((e) => Bill.fromMap(e.data())).toList();
      return bills;
    } catch (e) {
      rethrow;
    }
  }
}
