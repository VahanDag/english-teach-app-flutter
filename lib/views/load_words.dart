import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:teach_app/core/enums.dart';
import 'package:teach_app/repositories/words_repository.dart';
import 'package:teach_app/views/learn_game.dart';

class LoadWordsPage extends StatefulWidget {
  const LoadWordsPage({super.key});

  @override
  State<LoadWordsPage> createState() => _LoadWordsPageState();
}

class _LoadWordsPageState extends State<LoadWordsPage> {
  @override
  void initState() {
    super.initState();
    fetchWords();
  }

  Future<void> fetchWords() async {
    await context.read<WordsRepository>().fetchWords(englishLevel: "b-1", topic: TopicsImage.general.name);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LearnGamePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(height: 150, "assets/lottie/loading-words.json"),
            const Text("Senin için en iyi kelimeleri hazırlıyoruz..")
          ],
        ),
      ),
    );
  }
}
