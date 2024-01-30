import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future getCsrfToken() async {
  var uri = Uri.parse("http://127.0.0.1:8000/user/get-csrf-token/");
  var response = await http.get(uri);

  if (response.statusCode == 200) {
    return response.headers['x-csrftoken'] ?? "";
  } else {
    throw Exception('Failed to get CSRF token');
  }
}

//Future passVerify(String password){}

Future userlogin(String email, dynamic password) async {
  var uriLogin = Uri.parse("http://127.0.0.1:8000/user/login/");
  String csrfToken = await getCsrfToken();
  var res = await http.post(uriLogin,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {
        "Referer": "http://127.0.0.1:8000",
        "X-CSRFToken": csrfToken,
        'Content-Type': 'application/json'
      });

  print(res.body);
  print(res.statusCode);
  if ((res.statusCode == 200) ||
      (res.statusCode == 201) ||
      (res.statusCode == 202) ||
      (res.statusCode == 203) ||
      (res.statusCode == 204)) {
    var data = json.decode(res.body);
    var token = data['token'];
    print("got token in userlogin");
    print("Login Successful");
    print("login done");
    print(token);
    return LoginResponse(token, true);
  } else {
    print("Some Error Occured. Login is denied");
    return LoginResponse("", false);
  }
}

class LoginResponse {
  final String token;
  final bool auth;

  LoginResponse(this.token, this.auth);
}

Future userregister(String email, dynamic password, dynamic salt) async {
  var uriRegister = Uri.parse("http://127.0.0.1:8000/user/register/");
  String csrfToken = await getCsrfToken();
  print(csrfToken);
  print(email);
  print(password);
  http.Response res = await http.post(uriRegister,
      body: jsonEncode({
        'email': email,
        'password1': password,
        'password2': password,
        'salt': salt,
      }),
      headers: {
        //"Referer": "http://127.0.0.1:8000",
        "X-CSRFToken": csrfToken,
        'Content-Type': 'application/json'
      });

  print(res.body);
  print(res.statusCode);
  if ((res.statusCode == 200) ||
      (res.statusCode == 201) ||
      (res.statusCode == 202) ||
      (res.statusCode == 203) ||
      (res.statusCode == 204)) {
    print("Registration Successful");
    return true;
  } else {
    print("Some Error Occured. Registration is denied");
    return false;
  }
}

Future<UserResponse> UserInfo(String token) async {
  var uri = Uri.parse("http://127.0.0.1:8000/user/userInfo/");

  String csrfToken = await getCsrfToken();
  print(token);
  var headers = {
    'Authorization': 'Token $token',
    'X-CSRFToken': csrfToken,
  };
  var response = await http.get(uri, headers: headers);
  print(response.body);
  var data = json.decode(response.body);
  print(data);
  String password = data[0]['password'].toString();
  print(password);
  String salt = data[0]['salt'].toString();
  print(salt);
  String email = data[0]['email'];
  print(email);

  if (response.statusCode == 200) {
    print("Successful");
    return UserResponse(password, salt, email);
  } else {
    print("Some error occured. Access is denied.");
    return UserResponse("", "", "");
  }
}

class UserResponse {
  final String password;
  final String salt;
  final String email;
  UserResponse(this.password, this.salt, this.email);
}

// Future googlelogin() async {
//   GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

//     if (googleSignInAccount == null) {
//       return;
//     }

//     GoogleSignInAuthentication googleSignInAuthentication =
//         await googleSignInAccount.authentication;
    
//     String accessToken = googleSignInAuthentication.accessToken!;
//     String idToken = googleSignInAuthentication.idToken!;

//     print("Access Token: $accessToken");
//     print("ID Token: $idToken");

//   var uriLogin = Uri.parse("http://127.0.0.1:8000/user/google/login/");
//   String csrfToken = await getCsrfToken();
//   var res = await http.post(uriLogin,
//       // body: jsonEncode({
//       //   'email': email,
//       //   'password': password,
//       // }),
//       headers: {
//         "Referer": "http://127.0.0.1:8000",
//         "X-CSRFToken": csrfToken,
//         'Authorization': 'Token $accessToken',
//         'Content-Type': 'application/json'
//       });

//   print(res.body);
//   print(res.statusCode);
//   if ((res.statusCode == 200) ||
//       (res.statusCode == 201) ||
//       (res.statusCode == 202) ||
//       (res.statusCode == 203) ||
//       (res.statusCode == 204)) {
//     var data = json.decode(res.body);
//     var token = data['token'];
//     // print("got token in userlogin");
//     // print("Login Successful");
//     print("login done");
//     print(token);
//     return LoginResponse(token, true);
//   } else {
//     print("Some Error Occured. Login is denied");
//     return LoginResponse("", false);
//   }
// }