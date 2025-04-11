import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  final _firestore = FirebaseFirestore.instance;

  Future<bool> login(String username, String password) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }
}
