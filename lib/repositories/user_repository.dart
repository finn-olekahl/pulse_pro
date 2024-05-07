import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository{
  Future<bool> userExists(String userId) async {
    final data = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return data.exists;
  }
}