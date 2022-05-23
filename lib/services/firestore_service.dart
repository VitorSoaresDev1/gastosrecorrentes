import 'package:cloud_firestore/cloud_firestore.dart';
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
}
