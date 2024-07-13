import 'dart:math';

import 'package:flutter/material.dart';
import 'package:teach_app/models/word_model.dart';
import 'package:teach_app/service/firebase_service.dart';

class WordsRepository with ChangeNotifier {
  FirebaseService _firebaseService;
  List<WordModel>? _words;
  WordModel? _selectedLearnWord;

  WordsRepository(this._firebaseService);

  void updateService(FirebaseService firebaseService) {
    _firebaseService = firebaseService;
  }

  Future<void> fetchWords({required String englishLevel, required String topic}) async {
    _words = await _firebaseService.fetchWords(englishLevel: englishLevel, topic: topic);
    _selectedLearnWord = _words?[Random().nextInt(_words?.length ?? 0)];
    notifyListeners();
  }

  List<WordModel>? get words => _words;
  WordModel? get selectedLearnWord => _selectedLearnWord;
}
