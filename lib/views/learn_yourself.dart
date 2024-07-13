import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teach_app/core/custom_textfield.dart';
import 'package:teach_app/core/enums.dart';
import 'package:teach_app/core/extensions.dart';
import 'package:teach_app/core/paddings_borders.dart';
import 'package:teach_app/core/validators.dart';
import 'package:teach_app/models/learn_by_self_model.dart';
import 'package:teach_app/repositories/user_repository.dart';
import 'package:teach_app/views/drawing.dart';

class LearnYourself extends StatefulWidget {
  const LearnYourself({super.key});

  @override
  State<LearnYourself> createState() => _LearnYourselfState();
}

class _LearnYourselfState extends State<LearnYourself> {
  late final TextEditingController _turkishFormController;
  late final TextEditingController _englishFormController;
  final GlobalKey<FormState> _globalKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _turkishFormController = TextEditingController();
    _englishFormController = TextEditingController();
  }

  @override
  void dispose() {
    _turkishFormController.dispose();
    _englishFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: context.deviceWidth * 0.9,
          child: SingleChildScrollView(
            child: Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(height: 150, "assets/images/categories/dinasour2.png"),
                  Padding(
                    padding: PaddingConstant.paddingOnlyTopHigh,
                    child: Text(
                      "Kendin Öğren".toUpperCase(),
                      style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: PaddingConstant.paddingVerticalHigh,
                    child: Text(
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleSmall,
                        "Öğrenmek istediğin kelimeyi Türkçe ve İngilizce olarak aşağıya yaz ve daha sonra bu kelime için bir çizim oluştur!"),
                  ),
                  CustomTextField(
                      validator: (p0) {
                        return Validators.wordFieldValidator(p0);
                      },
                      inputAction: TextInputAction.next,
                      margin: PaddingConstant.paddingVerticalHigh,
                      hintText: "Türkçe",
                      controller: _turkishFormController),
                  CustomTextField(
                      validator: (p0) {
                        return Validators.wordFieldValidator(p0);
                      },
                      inputAction: TextInputAction.done,
                      margin: PaddingConstant.paddingVerticalHigh,
                      hintText: "İngilizce",
                      controller: _englishFormController),
                  Padding(
                    padding: PaddingConstant.paddingOnlyTopHigh,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          if (_globalKey.currentState?.validate() ?? false) {
                            final learningModel = WordByUserModel(
                                nativeWord: _turkishFormController.text.trim(),
                                targetLanguage: Languages.english,
                                targetWord: _englishFormController.text.trim());
                            final getNativeLang =
                                context.read<UserRepository>().user?.nativeLanguage ?? Languages.turkish.name;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DrawingPage(
                                          model: learningModel,
                                          nativeLanguage: getNativeLang,
                                        )));
                          }
                        },
                        label: const Text("Çizmeye başla"),
                        icon: const Icon(Icons.draw_outlined)),
                  ),
                  TextButton(onPressed: () {}, child: const Text("İngilizce'sini bilmiyorum.."))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
