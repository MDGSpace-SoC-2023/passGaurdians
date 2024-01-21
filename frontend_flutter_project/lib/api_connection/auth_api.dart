import 'dart:convert';

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
    var token = data['key'];
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
        'salt':salt,
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
