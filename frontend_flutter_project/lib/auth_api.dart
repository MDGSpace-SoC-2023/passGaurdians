import 'dart:convert';

import 'package:http/http.dart' as http;

String token = "";
Future getCsrfToken() async {
  var uri = Uri.parse("http://127.0.0.1:8000/user/get-csrf-token/");
  var response = await http.get(uri);

  if (response.statusCode == 200) {
    return response.headers['x-csrftoken'] ?? "";
  } else {
    throw Exception('Failed to get CSRF token');
  }
}

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
  if (res.statusCode == 200) {
    print("Login Successful");
    return true;
  } else {
    print("Some Error Occured. Login is denied");
    return false;
  }
}

Future userregister(String email, dynamic password) async {
  var uriRegister = Uri.parse("http://127.0.0.1:8000/user/register/");
  String csrfToken = await getCsrfToken();
  print(csrfToken);
  print(email);
  print(password);
  var res = await http.post(uriRegister,
      body: jsonEncode({
        'email': email,
        'password1': password,
        'password2': password,
      }),
      headers: {
        //"Referer": "http://127.0.0.1:8000",
        "X-CSRFToken": csrfToken,
        'Content-Type': 'application/json'
      });

  print(res.body);
  print(res.statusCode);
  if (res.statusCode == (200 | 204)) {
    print("Registration Successful");
    return true;
  } else {
    print("Some Error Occured. Registration is denied");
    return false;
  }
}
