import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teach_app/core/custom_border_container.dart';
import 'package:teach_app/core/custom_snackbar.dart';
import 'package:teach_app/core/custom_textfield.dart';
import 'package:teach_app/core/enums.dart';
import 'package:teach_app/core/extensions.dart';
import 'package:teach_app/core/paddings_borders.dart';
import 'package:teach_app/repositories/user_repository.dart';
import 'package:teach_app/routers.dart';
import 'package:teach_app/service/firebase_service.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late final TextEditingController _nameController;
  late final PageController _pageController;

  final List<EnglishLevels> _englishLevels = EnglishLevels.values;
  EnglishLevels? _selectedLevel;

  final List<TopicsImage> _topics = TopicsImage.values;
  final List<TopicsImage> _selectedTopics = [];

  static const List<String> _englisDesc = [
    "Yeni Başlayan (Beginner)", // A1
    "Temel Düzey (Elementary)", // A2
    "Orta Altı (Pre-Intermediate)", // B1
    "Orta Düzey (Intermediate)", // B2
    "İleri Düzey (Advanced)", // C1
    "Usta (Proficient)" // C2
  ];
  static const List<String> topicsNames = [
    "Genel", // general
    "Teknoloji", // tech
    "Otomotiv", // automotive
    "Spor", // sports
    "Müzik", // music
    "Tarih", // history
    "Politika", // politics
    "Filmler", // movie
    "Bilim", // science
    "Kitaplar", // books
    "Sanat", // art
    "Oyun", // gaming
    "Sağlık ve Fitness" // healtfitness
  ];
  bool _isLastPage = false;

  @override
  void initState() {
    _nameController = TextEditingController();
    _pageController = PageController();
    _pageController.addListener(
      () {
        setState(() {
          if (_pageController.page?.toInt() == 4) {
            _isLastPage = true;
          } else {
            _isLastPage = false;
          }
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _isLastPage
          ? const SizedBox.shrink()
          : FloatingActionButton(
              onPressed: () {
                _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linearToEaseOut);
              },
              backgroundColor: Colors.blue.shade300,
              child: Icon(
                Icons.arrow_forward,
                color: Colors.blue.shade900,
              ),
            ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                _pageFrame(iconName: "dinasour-signin", context: context, widgets: [
                  _text(text: "Hoşgeldin!", style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  _text(
                      text:
                          "Bu serüvene başlamadan önce senden birkaç ek blgiye daha ihtiyacımız olacak. Bu bilgiler İngilizce öğrenme sürecinde sana yardımcı olmamız için gerekli"),
                  _text(text: "Hazırsan başlayalım?", style: context.textTheme.titleMedium),
                ]),
                _pageFrame(iconName: "name", context: context, widgets: [
                  _text(
                      text: 'Öncelikle sana nasıl hitap etmemize karar vermemiz gerekiyor',
                      style: context.textTheme.titleSmall),
                  CustomTextField(margin: PaddingConstant.paddingOnlyTopHigh, hintText: "İsim", controller: _nameController)
                ]),
                _pageFrame(iconName: "english-level", context: context, widgets: [
                  _text(text: "Ha gayret, az kaldı!", style: context.textTheme.titleMedium),
                  _text(text: "Sana özel bir çalışma planı hazırlamamız için İngilizce seviyeni öğrenmemiz gerekiyor"),
                  customContainer(
                    margin: PaddingConstant.paddingVerticalHigh,
                    context: context,
                    width: double.infinity,
                    borderRadius: BorderRadiusConstant.borderRadiusMedium,
                    padding: PaddingConstant.paddingHorizontalMedium,
                    child: DropdownButton<EnglishLevels>(
                      underline: const SizedBox.shrink(),
                      isExpanded: true,
                      hint: const Text('Seviyenizi Seçin'),
                      value: _selectedLevel,
                      icon: Icon(_selectedLevel == null ? Icons.language_rounded : Icons.check),
                      items: _englishLevels.map((e) {
                        final isSelected = _selectedLevel == e;
                        return DropdownMenuItem<EnglishLevels>(
                            value: e,
                            child: Row(
                              children: [
                                Text("${e.name} ${isSelected ? '- ' : ''}",
                                    style: isSelected ? TextStyle(color: Colors.green.shade800) : null),
                                if (!isSelected) const Spacer(),
                                Text(_englisDesc[e.index],
                                    style: isSelected ? TextStyle(color: Colors.green.shade800) : null),
                              ],
                            ));
                      }).toList(),
                      onChanged: (value) => setState(() {
                        _selectedLevel = value;
                      }),
                    ),
                  ),
                ]),
                _pageFrame(iconName: "topics", context: context, widgets: [
                  _text(
                      text: "Son olarak bu serüveni eğlenceli kılmak için ilgi alanlarını seçelim",
                      style: context.textTheme.titleSmall),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _topics.length,
                      itemBuilder: (BuildContext context, int index) {
                        final isSelected = _selectedTopics.contains(_topics[index]);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedTopics.remove(_topics[index]);
                              } else {
                                _selectedTopics.add(_topics[index]);
                              }
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    colorFilter: isSelected ? null : const ColorFilter.mode(Colors.black, BlendMode.color),
                                    fit: BoxFit.cover,
                                    image: AssetImage(_topics[index].image)),
                                borderRadius: BorderRadiusConstant.borderRadiusMedium),
                            margin: PaddingConstant.paddingAll,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                Text(topicsNames[index],
                                    style: context.textTheme.headlineLarge
                                        ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]),
                _pageFrame(
                    context: context,
                    widgets: [
                      _text(
                          text: "Artık Hazırsın!",
                          style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      _text(
                          text: "Koltuklar dik, kemerler takılı, pencereler kapalı..  Şimdi gaza basma zamanı!",
                          style: context.textTheme.titleSmall),
                      _text(
                          text: "Arada bir camdan bakmayı unutma, her zaman yanında olduğumuzu göreceksin..",
                          style: context.textTheme.titleSmall),
                      Padding(
                        padding: PaddingConstant.paddingOnlyTopHigh,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_nameController.text.trim().isEmpty) {
                                _pageController.animateToPage(1,
                                    duration: const Duration(milliseconds: 500), curve: Curves.linear);
                                customSnackBar(context: context, title: "Bir isim girmelisin", isNegative: true);
                              } else if (_selectedLevel == null) {
                                _pageController.animateToPage(2,
                                    duration: const Duration(milliseconds: 500), curve: Curves.linear);
                                customSnackBar(context: context, title: "İngilizce seviyeni belirlemedin", isNegative: true);
                              } else if (_selectedTopics.isEmpty) {
                                _pageController.animateToPage(3,
                                    duration: const Duration(milliseconds: 500), curve: Curves.linear);
                                customSnackBar(context: context, title: "En az 1 alan belirle", isNegative: true);
                              } else {
                                final user = context.read<UserRepository>().user;
                                user?.englishLevel = _selectedLevel!.name;
                                user?.name = _nameController.text.trim();
                                final List<String> topics = [];
                                for (var element in _selectedTopics) {
                                  topics.add(element.name);
                                }
                                user?.interestTopics = topics;
                                print(user);
                                print(user?.name);
                                print(user?.interestTopics);
                                print(user?.interestTopics.runtimeType);
                                final update = await context.read<FirebaseService>().updateUser(user!);

                                if (update && mounted) {
                                  await context.read<UserRepository>().getUser();
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => const Routers()));
                                } else {
                                  customSnackBar(
                                      context: context, title: "Bilgilerini güncellerken bir hata oluştu", isNegative: true);
                                }
                              }
                            },
                            child: const Text("Kaydı Tamamla")),
                      )
                    ],
                    iconName: "dinasour-signup")
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _text({required String text, TextStyle? style}) {
    return Padding(
      padding: PaddingConstant.paddingVertical,
      child: Text(style: style ?? context.textTheme.bodyMedium, textAlign: TextAlign.center, text),
    );
  }

  Widget _pageFrame({required BuildContext context, required List<Widget> widgets, required String iconName}) {
    return Padding(
      padding: PaddingConstant.paddingHorizontalHigh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(height: 200, 'assets/images/icons/$iconName.png'),
          const SizedBox(height: 40),
          ...widgets
        ],
      ),
    );
  }
}

/**
 * 
 *   Image.asset(height: 250, width: 150, 'assets/images/icons/dinasour-signin.png'),
          Image.asset(height: 250, width: 150, 'assets/images/icons/name.png'),
          Image.asset(height: 250, width: 150, 'assets/images/icons/english-level.png'),

      
          _pageFrame(context: context, widgets: [
            const Text(textAlign: TextAlign.center, 'Öncelikle sana nasıl hitap etmemize karar vermemiz gerekiyor.'),
            CustomTextField(margin: PaddingConstant.paddingOnlyTopHigh, hintText: "İsim", controller: _nameController)
          ]),
          _pageFrame(context: context, widgets: [
            const Text(
                textAlign: TextAlign.center,
                'Şimdi de sana özel bir çalışma planı hazırlamamız için İngilizce seviyeni öğrenmemiz gerekiyor'),
            CustomTextField(margin: PaddingConstant.paddingOnlyTopHigh, hintText: "İsim", controller: _nameController),
          ])
 * 
 */
