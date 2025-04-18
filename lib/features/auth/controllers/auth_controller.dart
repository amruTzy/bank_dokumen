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

  Future<String?> getUserRole(String username) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first['role'];
      }
      return null;
    } catch (e) {
      print("Get role error: $e");
      return null;
    }
  }
}
