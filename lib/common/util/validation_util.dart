library validation_util;

import 'package:basic_utils/basic_utils.dart';

bool isValidId(String id) {
  if (StringUtils.isNullOrEmpty(id)) return false;
  if (id.length > 20 && id.length < 6) return false;
  if (RegExp(r'''[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]''').hasMatch(id)) return false;
  if (RegExp("/ /gi").hasMatch(id)) return false;
  if (RegExp(r"^[a-zA-Z0-9]*$").hasMatch(id) == false) return false;

  return true;
}

bool isNotValidId(String id) {
  return !isValidId(id);
}

bool isValidPassword(String password) {
  if (StringUtils.isNullOrEmpty(password)) return false;
  if (password.length > 30 && password.length < 8) return false;
  if (RegExp("/ /gi").hasMatch(password)) return false;
  if (RegExp(r"""(?=.*\d{1,50})(?=.*[~`!@#$%\^&*()-+=]{1,50})(?=.*[a-zA-Z]{2,50}).{8,50}$""").hasMatch(password) == false) return false;

  return true;
}

bool isMatchedPassword(String password, String confirmPassword) {
  return password == confirmPassword;
}

bool isNotValidPassword(String password) {
  return !isValidPassword(password);
}

bool isNotMatchedPassword(String password, String confirmPassword) {
  return !isMatchedPassword(password, confirmPassword);
}

bool isValidEmail(String email) {
  if (StringUtils.isNullOrEmpty(email)) return false;
  if (RegExp(r"""^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$""").hasMatch(email) == false) return false;

  return true;
}

bool isNotValidEmail(String email) {
  return !isValidEmail(email);
}