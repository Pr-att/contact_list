import 'dart:convert';
import 'dart:developer';
import 'package:contact_list/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const URI = 'https://a809-2405-201-6834-3013-b039-38dc-50ae-255d.in.ngrok.io';

class AuthService {
  signUpUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    http.Response response = await http.post(
      Uri.parse('$URI/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"email": email, "password": password}),
    );
    print("${response.body} ${response.statusCode}");

    switch (response.statusCode) {
      case 200:
        showSnackBar(context, "User created successfully, Please sign in.");
        return response.statusCode;
      case 400:
        return response.statusCode;
      case 401:
        showSnackBar(context, "Wrong password, Please try again.");
        return response.statusCode;
      case 503:
        showSnackBar(context, "Server is down, Please try again later.");
        return response.statusCode;
      default:
        showSnackBar(context, "Something went wrong, Please try again.");
        return response.statusCode;
    }
  }

  signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    http.Response response = await http.post(
      Uri.parse('$URI/signin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    print("${response.body} ${response.statusCode}");

    switch (response.statusCode) {
      case 200:
        showSnackBar(context, "User signed in successfully.");
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        return response.statusCode;
      case 401:
        showSnackBar(context, "Wrong password, Please try again.");
        return response.statusCode;
    }
  }

  updateUserContact({
    required BuildContext context,
    required String email,
    required String name,
    required int phone,
  }) async {
    http.Response response = await http.put(
      Uri.parse(
          '$URI/contacts'), // Replace with the correct URL for updating a user's contact
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "email": email,
        "contact": [
          {
            "name": name,
            "phone": phone,
          },
        ]
      }),
    );

    print("${response.body} ${response.statusCode}");
    switch (response.statusCode) {
      case 200:
        showSnackBar(context, "Contact updated successfully.");
        return response.statusCode;
      case 400:
        showSnackBar(context, "Bad request, please try again.");
        break;
      case 401:
        showSnackBar(context, "Unauthorized access, please try again.");
        break;
      case 404:
        showSnackBar(context, "Resource not found, please try again.");
        break;
      default:
        showSnackBar(context, "Something went wrong, please try again.");
        break;
    }
  }
}

// class MongoDataBase {
//   static connect() async {
//     var db = await Db.create(
//         "mongodb+srv://Yellow-Class-User-Name:V7fj9Tp5rRZS8cpd@yellow-class-cluster.zralhma.mongodb.net/test?retryWrites=true&w=majority");
//     await db.open();
//     inspect(db);
//     var collection = db.collection('users');
//     print(await collection.find().toList());
//     return db;
//   }
// }
