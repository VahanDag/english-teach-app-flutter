import 'dart:math' as math;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:teach_app/core/enums.dart';
import 'package:teach_app/models/learn_by_self_model.dart';
import 'package:teach_app/models/user_model.dart';
import 'package:teach_app/models/word_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> createUser(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final model = UserModel(email: email, uid: credential.user?.uid);

      await _firestore.collection("users").doc(model.uid).set(model.toMap());
      return true;
    } catch (e) {
      // Error handling
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return true;
    } catch (e) {
      // Error handling
      return false;
    }
  }

  Future<UserModel?> fetchUserData() async {
    print("AUTH BURDA ${_auth.currentUser}");
    if (_auth.currentUser != null) {
      final snapshot = await _firestore.collection("users").doc(_auth.currentUser!.uid).get();
      print("USER BURDA ${snapshot.data()}");
      if (snapshot.data() == null) {
        return null;
      }
      final userModel = UserModel.fromMap(snapshot.data()!);
      print("USERMODEL $userModel");
      userModel.learningWord = await getLearningWords();
      print("USERMODEleanL ${userModel.learningWord}");

      return userModel;
    } else {
      return null;
    }
  }

  Future<bool> updateUser(UserModel model) async {
    try {
      await _firestore.collection("users").doc(model.uid).update(model.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveLearningWord(WordByUserModel model, String nativeLanguage) async {
    try {
      model.timestamp = Timestamp.now();
      model.owner = _auth.currentUser?.uid;
      model.isLearned = false;
      await _firestore
          .collection("users")
          .doc(_auth.currentUser?.uid)
          .collection("$nativeLanguage-${model.targetLanguage?.name ?? Languages.english.name}")
          .add(model.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String?> saveWordImage(
      {required Uint8List pngBytes, required WordByUserModel model, required String nativeLanguage}) async {
    try {
      final ref = _storage.ref().child(
          "images/${_auth.currentUser?.uid}/$nativeLanguage-${model.targetLanguage?.name}/${model.nativeWord}-${model.targetWord}-${model.targetLanguage?.name}.png");

      UploadTask uploadTask = ref.putData(pngBytes);
      await uploadTask.whenComplete(() => print("Resim başarıyla yüklendi"));

      String downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<WordByUserModel>> getLearningWords() async {
    print("getLearn ${_auth.currentUser?.uid}");
    final snapshot = await _firestore.collection("users").doc(_auth.currentUser?.uid).collection("turkish-english").get();
    print("getLearnDOC ${snapshot.docs}");
    print("getLearnDOCLENGHT ${snapshot.docs.length}");

    List<WordByUserModel> model = [];
    for (var word in snapshot.docs) {
      print("word burda  ${word.data()}");
      model.add(WordByUserModel.fromMap(word.data()));
    }
    return model;
  }

  Future<List<WordModel>> fetchWords({required String englishLevel, required String topic}) async {
    final ref = _firestore.collection(englishLevel).doc(topic).collection("words");

    List<WordModel> model = [];

    for (var i = 1; i < 5; i++) {
      final randomNum = math.Random().nextInt(5) + 1;
      final snapshot = await ref.doc(randomNum.toString()).get();
      final data = snapshot.data();
      model.add(WordModel.fromMap(data ?? {}));
    }

    return model;
  }
}
