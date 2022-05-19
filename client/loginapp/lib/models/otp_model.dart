class Otp {
  final String? email;
  final String? otp;
  Otp({
    this.email,
    this.otp,
  });
  factory Otp.fromJson(Map<String, dynamic> json) {
    return Otp(
      email: json['email'],
      otp: json['otp'],
    );
  }
  static Map<String, dynamic> toJson(Otp value) =>
      {'email': value.email, 'otp': value.otp};
}
