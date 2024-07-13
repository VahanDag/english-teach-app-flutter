import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teach_app/core/custom_snackbar.dart';
import 'package:teach_app/core/custom_textfield.dart';
import 'package:teach_app/core/extensions.dart';
import 'package:teach_app/core/paddings_borders.dart';
import 'package:teach_app/core/validators.dart';
import 'package:teach_app/repositories/user_repository.dart';
import 'package:teach_app/routers.dart';
import 'package:teach_app/service/firebase_service.dart';
import 'package:teach_app/views/welcome/welcome.dart';

class AuthPage extends StatefulWidget {
  AuthPage({
    super.key,
    required this.isRegisterPage,
  });

  bool isRegisterPage;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _create(String email, String password, bool isLogin) async {
    final ref = context.read<FirebaseService>();
    final loginOrCreate = await (isLogin ? ref.login(email, password) : ref.createUser(email, password));
    if (loginOrCreate && mounted) {
      await context.read<UserRepository>().getUser();
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => isLogin ? const Routers() : const WelcomePage()));
      }
    } else {
      customSnackBar(
          context: context, title: isLogin ? "Email veya Şifre yanlış" : "Bazı sorunlar oluştu :/", isNegative: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: context.deviceWidth * 0.8,
            child: Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                      height: 150,
                      "assets/images/icons/${widget.isRegisterPage ? 'dinasour-signup' : 'dinasour-signin'}.png"),
                  const SizedBox(height: 40.0),
                  CustomTextField(
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: (p0) {
                      return Validators.emailValidator(p0);
                    },
                    controller: _emailController,
                    hintText: 'Email',
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    validator: (p0) {
                      return Validators.passwordValidator(p0);
                    },
                    controller: _passwordController,
                    hintText: 'Password',
                    isPassword: true,
                  ),
                  const SizedBox(height: 24.0),
                  SizedBox(
                    width: context.deviceWidth * 0.75,
                    child: OutlinedButton(
                        style: const ButtonStyle(shape: WidgetStatePropertyAll(ContinuousRectangleBorder())),
                        onPressed: () async {
                          if (_globalKey.currentState?.validate() ?? false) {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();

                            await _create(email, password, !widget.isRegisterPage);
                          }
                        },
                        child: Text(widget.isRegisterPage ? "Kaydol" : "Giriş Yap")),
                  ),
                  const SizedBox(height: 24.0),
                  Column(
                    children: [
                      const Row(
                        children: [
                          Expanded(child: Divider(thickness: 2)),
                          Padding(
                            padding: PaddingConstant.paddingHorizontal,
                            child: Text("Veya"),
                          ),
                          Expanded(child: Divider(thickness: 2)),
                        ],
                      ),
                      Padding(
                        padding: PaddingConstant.paddingVerticalHigh,
                        child: ListTile(
                          shape: BeveledRectangleBorder(
                              side: BorderSide(color: Colors.grey.shade600),
                              borderRadius: BorderRadiusConstant.borderRadiusMedium),
                          leading: Image.asset(height: 35, "assets/images/icons/google.png"),
                          title: Text(
                            "Google ile devam et",
                            style: context.textTheme.titleMedium,
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                        ),
                      ),
                      if (widget.isRegisterPage)
                        TextButton.icon(
                            onPressed: () {
                              setState(() {
                                widget.isRegisterPage = false;
                              });
                            },
                            label: const Text("Zaten hesabın var mı? Giriş Yap"),
                            icon: const Icon(Icons.arrow_back))
                      else
                        TextButton.icon(
                            icon: const Icon(Icons.people),
                            onPressed: () {
                              setState(() {
                                widget.isRegisterPage = true;
                              });
                            },
                            label: const Text("Hesabın yok mu? Kaydol"))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
