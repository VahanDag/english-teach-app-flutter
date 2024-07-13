import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teach_app/core/enums.dart';

class WordByUserModel {
  String? nativeWord;
  String? targetWord;
  Languages? targetLanguage;
  String? wordImageUrl;
  String? wordTopic;
  Timestamp? timestamp;
  String? owner;
  bool? isLearned;

  WordByUserModel({
    this.nativeWord,
    this.targetWord,
    this.targetLanguage,
    this.wordImageUrl,
    this.wordTopic,
    this.timestamp,
    this.isLearned,
    this.owner,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nativeWord': nativeWord,
      'targetWord': targetWord,
      'targetLanguage': targetLanguage?.name, // Enum değerini string'e dönüştür
      'wordImageUrl': wordImageUrl,
      'wordTopic': wordTopic,
      'timestamp': timestamp,
      'isLearned': isLearned,
      'owner': owner,
    };
  }

  factory WordByUserModel.fromMap(Map<String, dynamic> map) {
    return WordByUserModel(
      nativeWord: map['nativeWord'] != null ? map['nativeWord'] as String : null,
      targetWord: map['targetWord'] != null ? map['targetWord'] as String : null,
      targetLanguage: map['targetLanguage'] != null
          ? Languages.values.byName(map['targetLanguage'])
          : null, // String'i enum değerine dönüştür
      wordImageUrl: map['wordImageUrl'] != null ? map['wordImageUrl'] as String : null,
      wordTopic: map['wordTopic'] != null ? map['wordTopic'] as String : null,
      timestamp: map['timestamp'] != null ? map['timestamp'] as Timestamp : null,
      owner: map['owner'] != null ? map['owner'] as String : null,
      isLearned: map['isLearned'] != null ? map['isLearned'] as bool : null,
    );
  }
}
