// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teach_app/core/extensions.dart';
import 'package:teach_app/core/paddings_borders.dart';
import 'package:teach_app/models/user_model.dart';
import 'package:teach_app/repositories/user_repository.dart';
import 'package:teach_app/views/global_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.changedPageIndex,
  });
  final Function(int index)? changedPageIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final UserModel? _user;
  @override
  void initState() {
    _user = context.read<UserRepository>().user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // ElevatedButton(
              //     onPressed: () async {
              //       await FirebaseFirestore.instance
              //           .collection("b-1")
              //           .doc(TopicsImage.general.name)
              //           .collection("words")
              //           .doc(6.toString())
              //           .set(WordModel(
              //                   englishLevel: EnglishLevels.B1.name,
              //                   id: 6,
              //                   imageUrl:
              //                       "https://firebasestorage.googleapis.com/v0/b/english-teach-app.appspot.com/o/B-1%2Fresim_2024-07-12_020340016.png?alt=media&token=cfaa2648-8abf-4801-888c-b2f4de8453b9",
              //                   otherLanguage: {
              //                     Languages.turkish.name: "mühendis",
              //                   },
              //                   topic: TopicsImage.general.name,
              //                   word: "engineer")
              //               .toMap());
              //     },
              //     child: const Text("data")),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: context.deviceHeight * 0.3,
                    width: context.deviceWidth,
                    padding: PaddingConstant.paddingOnlyLeftMedium,
                    color: Colors.blue.shade800,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Hoşgeldin,",
                              style: context.textTheme.headlineSmall
                                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${_user?.name?.toUpperCase()}!",
                              style: context.textTheme.headlineSmall
                                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Image.asset(height: 100, "assets/images/categories/dinasour2.png"),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    child: Card(
                      child: Container(
                        padding: PaddingConstant.paddingOnlyLeftMedium,
                        height: context.deviceHeight * 0.125,
                        width: context.deviceWidth * 0.8,
                        decoration: BoxDecoration(borderRadius: BorderRadiusConstant.borderRadius),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Bugün öğrenilen kelimeler",
                              style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                            ),
                            Text(
                              "3/10",
                              style: context.textTheme.titleLarge,
                            ),
                            Container(
                              margin: PaddingConstant.paddingOnlyBottomLow,
                              height: 20,
                              width: context.deviceWidth * 0.7,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Colors.pink.shade200, Colors.pink.shade800]),
                                  borderRadius: BorderRadiusConstant.borderRadius),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: context.deviceWidth * 0.9,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _contentTextContainer(context: context, text: "Günün Kelimesi"),
                        Container(
                          alignment: Alignment.center,
                          height: context.deviceHeight * 0.2,
                          width: context.deviceWidth,
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.color),
                                  image: NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9uwVL-kdsGnDVaUV2XWKxxaEu9WDYJP_mHQ&s")),
                              borderRadius: BorderRadiusConstant.borderRadiusMedium),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "KALEM",
                                style: context.textTheme.titleLarge?.copyWith(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30, letterSpacing: 2),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  // await FirebaseAuth.instance.signOut();
                                  final user = context.read<UserRepository>().user;
                                  print(user);
                                  print(user?.email);
                                },
                                label: const Text("Öğren"),
                                icon: const Icon(Icons.location_searching),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _contentTextContainer(context: context, text: "Öğrendiğin kelimeler"),
                        Container(
                          alignment: Alignment.center,
                          height: context.deviceHeight * 0.2,
                          child: (_user?.learnedWord?.isEmpty ?? true)
                              ? userHasNoLearnWord(context: context, text: "Henüz hiç kelime öğrenmemişsin")
                              : ListView.builder(
                                  itemCount: 10,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      margin: PaddingConstant.paddingHorizontal,
                                      width: 200,
                                      decoration: BoxDecoration(
                                          color: Colors.yellow, borderRadius: BorderRadiusConstant.borderRadiusMedium),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                    Card(
                      margin: PaddingConstant.paddingVerticalHigh,
                      child: Column(
                        children: [
                          ListTile(
                              leading: const Icon(Icons.book),
                              onTap: () {
                                widget.changedPageIndex?.call(1);
                              },
                              title: const Text("Öğren"),
                              trailing: const Icon(Icons.open_in_new_rounded)),
                          ListTile(
                              leading: const Icon(Icons.draw_outlined),
                              onTap: () {
                                widget.changedPageIndex?.call(2);
                              },
                              title: const Text("Çiz"),
                              trailing: const Icon(Icons.open_in_new_rounded)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentTextContainer({required BuildContext context, required String text, Color? color, double? size}) {
    return Padding(
      padding: PaddingConstant.paddingOnlyBottom,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: PaddingConstant.paddingOnlyRightLow,
            height: 30,
            width: 10,
            decoration: BoxDecoration(
                borderRadius: BorderRadiusConstant.borderRadiusLow,
                gradient: LinearGradient(colors: [Colors.pink.shade300, Colors.pink.shade700])),
          ),
          Text(
            text.toUpperCase(),
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: color, fontSize: size),
          ),
        ],
      ),
    );
  }
}
