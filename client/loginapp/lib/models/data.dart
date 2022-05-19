import 'package:hive/hive.dart';
part 'data.g.dart';

@HiveType(typeId: 1)
class Data {
  @HiveField(0)
  final String? username;
  @HiveField(1)
  final String? email;
  @HiveField(2)
  final int? age;
  @HiveField(3)
  final String? folowers;
  @HiveField(4)
  final int? posts;
  @HiveField(5)
  final String? jwt;

  Data({
    this.username,
    this.email,
    this.age,
    this.folowers,
    this.posts,
    this.jwt,
  });
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      username: json['username'],
      email: json['email'],
      age: json['age'],
      folowers: json['folowers'],
      posts: json['posts'],
      jwt: json['jwt'],
    );
  }
  static Map<String, dynamic> toJson(Data value) => {
        'username': value.username,
        'email': value.email,
        'age': value.age,
        'folowers': value.folowers,
        'posts': value.posts,
        'jwt': value.jwt,
      };
}
//  OTP Model for Client Side


/*     গুরুত্বপূর্ণ নোটঃ ক্লাইন্ট থেকে সার্ভারে ডাটা পাঠাতে গেলে  অবশ্যই ঐ ডাটাকে
        জিসন স্ট্রিং এ কনভার্ট করে নিতে হবে। এবং সার্ভার থেকে ডাটা রিসিভ করতে হলে জিসন স্ট্রিং ডাটাকে 
        অবজেক্ট ডাটাতে পরিনত করে ব্যবহার করতে হয়।
        মনে রাখতে হবে জিসন স্ট্রিং আর ডার্টের ম্যাপ ডাটা টাইপ এক নয়।
        জিসন স্ট্রিং এর কী এবং ভ্যালু উভয়ই স্ট্রিং, 

        *** অবজেক্ট ডাটা কে প্রথমে tojson() দিয়ে ম্যাপ ডাটা টাইপে পরিনত করতে হবে, 
        এরপর ঐ ম্যাপ ডাটাকে jsonEncode() দিয়ে জিসন স্ট্রিং ডাটাতে পরিনত করতে হবে।

        *** জিসন স্ট্রিং ডাটা কে প্রথমে jsonDecode() দিয়ে ম্যাপ ডাটা টাইপে পরিনত করতে হবে, 
        এরপর ঐ ম্যাপ ডাটাকে fromjson() দিয়ে অবজেক্ট ডাটাতে পরিনত করতে হবে।

        tojson() == অবজেক্ট ডাটা কে ম্যাপ ডাটায় কনভার্ট করে।
        fromjson()  == ম্যাপ ডাটা কে অবজেক্ট ডাটায় কনভার্ট করে।
        jsonDecode() == জিসন স্ট্রিং ডাটা কে ম্যাপ ডাটায় কনভার্ট করে।
        jsonEncode() == ম্যাপ ডাটা কে জিসন স্ট্রিং ডাটায় কনভার্ট করে।

        উল্লেখ্যঃ 
        ম্যাপ ডাটা টাইপঃ      Map<String, dynamic> == {'username': Sohel Rana, 'age': 30, 'sex': 'male'}
        জিসন স্ট্রিং ডাটা টাইপঃ Map<String, String> == {'username': "Sohel Rana", "age": "30", "sex" : "male" }
         অবজেক্ট ডাটা টাইপঃ  {username: "Sohel Rana" , age: 30, sex: "male"}

         
        */