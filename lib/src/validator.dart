class Validator {
  static String? sprawdzEmail({required String email}) {
    if (email == null) {
      return null;
    }
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    // wyrazenie regularne które sprawdza czy wpisany adres email jest poprawny
    if (email.isEmpty) {
      // warunek czy pole jest puste
      return 'Adres email nie może być pusty'; // zwracam komunikat
    } else if (!emailRegExp.hasMatch(email)) {
      // czy email spełnia wyrażenie regularne
      return 'Wpisz poprawny email'; // zwracam komunikat
    }

    return null;
  }

  static String? sprawdzHaslo({required String password}) {
    if (password == null) {
      return null;
    }
    RegExp passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_]).{8,}$');
// wyrazenie regularne sprawdzające poziom hasła
// przynajmniej 1 wielka litera, jedna mała litera, znak specjalny, cyfra i minimum 8 znaków
    if (password.isEmpty) {
      // warunek czy pole jest puste
      return 'Hasło nie może być puste'; // zwracam komunikat
    } else if (!passwordRegExp.hasMatch(password)) {
      // czy hasło spełnia wyrażenie regularne
      return 'Hasło musi mieć conajmniej 8 znaków'; // zwracam komunikat
    }

    return null;
  }

  static String? validateText({required String? text}) {
    if (text == null) {
      return null;
    }
    if (text.isEmpty) {
      // warunek czy pole jest puste
      return 'to pole nie moze byc puste'; // zwracam komunikat
    } else if (text.length < 3) {
      // czy wpisano przynajmniej 3 znaki
      return 'wpisz przynajmniej 3 znaki'; // zwracam komunikat
    }
    return null;
  }
}
