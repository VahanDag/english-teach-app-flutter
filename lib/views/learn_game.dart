import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:teach_app/core/custom_snackbar.dart';
import 'package:teach_app/core/enums.dart';
import 'package:teach_app/core/extensions.dart';
import 'package:teach_app/core/paddings_borders.dart';
import 'package:teach_app/models/word_model.dart';
import 'package:teach_app/repositories/words_repository.dart';

class LearnGamePage extends StatefulWidget {
  const LearnGamePage({super.key});

  @override
  State<LearnGamePage> createState() => _LearnGamePageState();
}

class _LearnGamePageState extends State<LearnGamePage> with SingleTickerProviderStateMixin {
  late final List<WordModel> _words;
  late final WordModel _learningWord;
  bool _isTrue = false;
  late final AnimationController _animationController;
  int _clickedIndex = -1;

  @override
  void initState() {
    super.initState();
    _words = context.read<WordsRepository>().words!;
    _learningWord = context.read<WordsRepository>().selectedLearnWord!;
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            Navigator.pop(context);
          }
        },
      );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Lottie.asset(
            "assets/lottie/success2.json",
            controller: _animationController,
            onLoaded: (composition) {
              _animationController
                ..duration = composition.duration
                ..forward();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () {},
            label: const Text("Öğrenmeyi bitir"),
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: Center(
        child: SizedBox(
          width: context.deviceWidth * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 20, mainAxisSpacing: 20, crossAxisCount: 2, mainAxisExtent: 175),
                  itemCount: _words.length,
                  itemBuilder: (BuildContext context, int index) {
                    final WordModel wordModel = _words[index];
                    return GestureDetector(
                      onTap: _isTrue
                          ? null
                          : () {
                              setState(() {
                                if (_clickedIndex == index) {
                                  _clickedIndex = -1;
                                } else {
                                  _clickedIndex = index;
                                }
                              });
                            },
                      child: Card(
                        elevation: 10,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadiusConstant.borderRadiusMedium,
                              image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(_clickedIndex == index ? 0.5 : 0), BlendMode.darken),
                                  fit: BoxFit.cover,
                                  image: NetworkImage(wordModel.imageUrl!))),
                          child: Text(
                            _clickedIndex == index ? wordModel.word!.toUpperCase() : "",
                            style:
                                context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: PaddingConstant.paddingVerticalHigh,
                child: RichText(
                    text: TextSpan(style: context.textTheme.titleMedium, children: [
                  TextSpan(
                      text: _learningWord.otherLanguage![Languages.turkish.name].toUpperCase(),
                      style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const TextSpan(text: "  resmini seç")
                ])),
              ),
              Padding(
                padding: PaddingConstant.paddingVerticalHigh,
                child: ElevatedButton(
                    onPressed: () {
                      if (_isTrue) {
                      } else {
                        if (_clickedIndex != -1) {
                          if (_words[_clickedIndex].word == _learningWord.word) {
                            setState(() {
                              _isTrue = true;
                            });
                            _showSuccessDialog();
                          } else {
                            customSnackBar(context: context, title: "Resimlere iyi bak", isNegative: true);
                          }
                        } else {
                          customSnackBar(context: context, title: "Lütfen doğru resmi seç", isNegative: true);
                        }
                      }
                    },
                    child: Text(_isTrue ? "Devam et" : "Kontrol et")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
