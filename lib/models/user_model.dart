import 'package:teach_app/models/learn_by_self_model.dart';

class UserModel {
  String? username;
  String? englishLevel;
  String? nativeLanguage;
  String? email;
  List<WordByUserModel>? learnedWord;
  List<WordByUserModel>? learningWord;
  List<dynamic>? interestTopics;
  int? dailyWordGoal;
  String? uid;
  String? name;
  String? userAvatar;
  UserModel({
    this.username,
    this.englishLevel,
    this.email,
    this.learnedWord,
    this.learningWord,
    this.dailyWordGoal,
    this.uid,
    this.name,
    this.userAvatar,
    this.interestTopics,
    this.nativeLanguage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'englishLevel': englishLevel,
      'email': email,
      'dailyWordGoal': dailyWordGoal,
      'uid': uid,
      'name': name,
      'userAvatar': userAvatar,
      'interestTopics': interestTopics,
      'nativeLanguage': nativeLanguage,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] != null ? map['username'] as String : null,
      englishLevel: map['englishLevel'] != null ? map['englishLevel'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      interestTopics: map['interestTopics'],
      dailyWordGoal: map['dailyWordGoal'] != null ? map['dailyWordGoal'] as int : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      userAvatar: map['userAvatar'] != null ? map['userAvatar'] as String : null,
      nativeLanguage: map['nativeLanguage'] != null ? map['nativeLanguage'] as String : null,
    );
  }
}
