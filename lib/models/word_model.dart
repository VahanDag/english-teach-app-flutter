import 'dart:convert';

class WordModel {
  final String? word;
  final int? id;
  final String? imageUrl;
  final Map<dynamic, dynamic>? otherLanguage;
  final String? englishLevel;
  final String? topic;
  WordModel({
    this.word,
    this.id,
    this.imageUrl,
    this.otherLanguage,
    this.englishLevel,
    this.topic,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'word': word,
      'id': id,
      'imageUrl': imageUrl,
      'otherLanguage': otherLanguage,
      'englishLevel': englishLevel,
      'topic': topic,
    };
  }

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      word: map['word'] != null ? map['word'] as String : null,
      id: map['id'] != null ? map['id'] as int : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      otherLanguage: map['otherLanguage'],
      englishLevel: map['englishLevel'] != null ? map['englishLevel'] as String : null,
      topic: map['topic'] != null ? map['topic'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());
}
