import 'package:basic_utils/basic_utils.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:inspection/inspection.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class FormValidator {
  //For name form validation
  static String validateName(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return 'Invalid name'.tr();
    }
    return null;
  }

  //For email address form validation
  static String validateEmail(String value) {
    if (value.isEmpty || !EmailUtils.isEmail(value)) {
      return 'Invalid email address'.tr();
    }
    return null;
  }

  //For email address form validation
  static String validatePhone(String value, {String name}) {
    return Inspection().inspect(
      value,
      'required|numeric|min:3|max:16',
      name: name,
    );
  }

  //For email address form validation
  static String validatePassword(String value) {
    if (value.isEmpty || value.trim().isEmpty || value.length < 6) {
      return 'Password must be more than 6 character'.tr();
    }
    return null;
  }

  static String validateEmpty(String value, {String errorTitle}) {
    if (value.isEmpty || value.trim().isEmpty || value.length < 6) {
      return '$errorTitle ' + 'is empty'.tr();
    }
    return null;
  }

  static String validateCustom(String value,
      {String name, String rules = "required"}) {
    return Inspection().inspect(
      value,
      rules,
      name: name,
      locale: I18n.localeStr,
    );
  }
}
