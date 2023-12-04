
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

String? validateWeight(String? value){
  bool isDouble = false;
  try {
    double.parse(value!);
    isDouble = true;
  } catch (e) {
    isDouble =  false;
  }
  if(value!.isEmpty){
    return "El peso es obligatorio";
  }else if(isDouble == false || value[value.length-1] == '.'){
    return "El peso introducido no tiene el formato correcto";
  }else{
    if(double.parse(value) > 150 || double.parse(value) < 25.0){
      return "El peso no es coherente";
    }
  }
  return null;
}

String? validateHeight(String? value){
  bool isDouble = false;
  try {
    double.parse(value!);
    isDouble = true;
  } catch (e) {
    isDouble =  false;
  }
  if(value!.isEmpty){
    return "La altura es obligatoria";
  }else if(isDouble == false || value[value.length-1] == '.'){
    return "La altura introducida no tiene el formato correcto";
  }else if(double.parse(value) > 2.60 || double.parse(value) < 1.2){
    return "La altura no es coherente";
  }
  return null;
}

String? validateUpdateInputsExercise(String? value) {
  if (value!.isEmpty) {
    return "El campo es obligatorio";
  } else if (value.length < 5) {
    return "Debe tener al menos 5 caracteres";
  } 
  return null;
}

String? validateNumber(String? value) {
  if (value!.isEmpty) {
    return "El campo es obligatorio";
  } else if (int.parse(value) < 1 ||  int.parse(value) > 10 ) {
    return "El número de ejercicios debe estar comprendido entre 1 y 10";
  } 
  return null;
}
