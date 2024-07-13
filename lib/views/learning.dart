import 'package:flutter/material.dart';
import 'package:teach_app/core/extensions.dart';
import 'package:teach_app/core/paddings_borders.dart';
import 'package:teach_app/views/find_friends.dart';
import 'package:teach_app/views/load_words.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: context.deviceWidth * 0.9,
            child: Column(
              children: [
                _learnCard(
                  icon: Icons.search,
                  buttonText: "Arkadaş ara",
                  context: context,
                  imageUrl: "https://wallpapers.com/images/hd/office-desk-next-to-a-window-22pzglrcerlfkhzr.jpg",
                  title: "Karşılıklı Oyna",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FindFirendsPage(),
                        ));
                  },
                ),
                _learnCard(
                  icon: Icons.location_searching,
                  buttonText: "Başla",
                  context: context,
                  imageUrl:
                      "https://img.freepik.com/free-photo/flat-lay-workstation-with-cup-tea-copy-space_23-2148430864.jpg",
                  title: "Bireysel Öğren",
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoadWordsPage(),
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded _learnCard(
      {required BuildContext context,
      required String title,
      required String imageUrl,
      void Function()? onPressed,
      required IconData icon,
      required String buttonText}) {
    return Expanded(
      child: Container(
        margin: PaddingConstant.paddingVerticalHigh,
        width: context.deviceWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.color),
              image: NetworkImage(imageUrl)),
          borderRadius: BorderRadiusConstant.borderRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: PaddingConstant.paddingVerticalMedium,
              child: Text(
                title,
                style: context.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton.icon(onPressed: onPressed, label: Text(buttonText), icon: Icon(icon)),
          ],
        ),
      ),
    );
  }
}
