extension ExtString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp =
        RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return passwordRegExp.hasMatch(this);
  }

  bool get isNotNull {
    return this != null;
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidOTP {
    final phoneRegExp = RegExp(r"^[0-9]{4}$");
    return phoneRegExp.hasMatch(this);
  }
}

/*
For the validation, we want the users of our app to fill in the correct details in each of these fields. The logic will be defined as such:

First, for the name field, we want the user to enter a valid first name and last name, which can be accompanied by initials.

For the email field, we want a valid email that contains some characters before the “@” sign, as well as the email domain at the end of the email.

For phone number validation, the user is expected to input 11 digits starting with the digit zero.

Finally, for our password validation, we expect the user to use a combination of an uppercase letter, a lowercase letter, a digit, and special character.
*/ 
