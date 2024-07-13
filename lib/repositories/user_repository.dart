import 'package:flutter/material.dart';
import 'package:teach_app/models/user_model.dart';
import 'package:teach_app/service/firebase_service.dart';

class UserRepository extends ChangeNotifier {
  FirebaseService _firebaseService;
  UserModel? user;

  UserRepository(this._firebaseService);

  void updateService(FirebaseService firebaseService) {
    _firebaseService = firebaseService;
  }

  Future<void> getUser() async {
    final getUser = await _firebaseService.fetchUserData();
    if (getUser != null) {
      user = getUser;
      notifyListeners();
    }
  }
}
