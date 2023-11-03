
String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "El correo es obligatorio";
    } else if (!regExp.hasMatch(value)) {
      return "Correo inválido";
    } else {
      return null;
    }
}

String? validatePassword(String? value) {
  if (value!.isEmpty) {
    return "La contraseña es obligatoria";
  } else if (value.length < 4) {
    return "La contraseña debe de tener al menos 4 caracteres";
  }
  return null;
}

String? validateName(String? value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value!.isEmpty) {
    return "El nombre es obligatorio";
  } else if (value.length < 2) {
    return "El nombre debe de tener al menos dos caracteres";
  } else if (!regExp.hasMatch(value)) {
    return "El nombre debe de ser a-z y A-Z";
  }
  return null;
}