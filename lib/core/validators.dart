import 'package:teach_app/core/regex_constant.dart';

mixin Validators {
  static String? wordFieldValidator(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return "Bir kelime girin";
    } else {
      return null;
    }
  }

  static String? emailValidator(String? value) {
    final mail = value?.trim() ?? "";
    if (mail.isEmpty) {
      return "E-posta gerekli";
    } else if (!RegexConstant.emailRegex.hasMatch(mail)) {
      return "Geçerli bir e-posta girin";
    } else {
      return null;
    }
  }

  static String? passwordValidator(String? value) {
    final password = value?.trim() ?? "";
    if (password.isEmpty) {
      return "Şifre boş olamaz";
    } else if (password.length < 6) {
      return "Şifre 6 karakterden küçük olamaz";
    } else {
      return null;
    }
  }
}
