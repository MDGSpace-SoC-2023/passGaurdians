import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loginuicolors/api_connection/auth_api.dart';

// Future getCsrfTokenPasswordStorage() async {
//   var uri = Uri.parse("http://127.0.0.1:8000/passwordStorageApp/csrf_token/");
//   var response = await http.get(uri);

//   if (response.statusCode == 200) {
//     return response.headers['x-csrftoken'] ?? "";
//   } else {
//     throw Exception('Failed to get CSRF token');
//   }
// }

// Future getToken() async {
//   var uri = Uri.parse("http://127.0.0.1:8000/user/token/");
//   var response = await http.get(uri);

//   if (response.statusCode == 200) {
//     return response.headers['Token'] ?? "";
//   } else {
//     throw Exception('Failed to get Token');
//   }
// }

Future Create(String title, String username, dynamic password, String website,
    String details) async {
  var uriListCreate =
      Uri.parse("http://127.0.0.1:8000/passwordStorageApp/passwordStorage/");
  String csrfToken = await getCsrfToken();
  var res = await http.post(uriListCreate,
      body: jsonEncode({
        "title": title,
        "username": username,
        "password": password,
        "website": website,
        "details": details,
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
    print("Suceesful");
    return true;
  } else {
    print("Some Error Occured. Access is denied");
    return false;
  }
}

Future Update(int pk, String title, String username, dynamic password,
    String website, String details) async {
  var uriUpdate =
      Uri.parse("http://127.0.0.1:8000/passwordStorageApp/$pk/update");
  String csrfToken = await getCsrfToken();
  print(csrfToken);
  var res = await http.post(uriUpdate,
      body: jsonEncode(
        {
          "title": title,
          "username": username,
          "password": password,
          "website": website,
          "details": details,
        },
      ),
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
    print("Successful");
    return true;
  } else {
    print("Some Error Occured. Access is denied");
    return false;
  }
}

Future ListPasswords(String token) async {
  var uri =
      Uri.parse("http://127.0.0.1:8000/passwordStorageApp/passwordStorage/");

  String csrfToken = await getCsrfToken();
  print(token);
  var headers = {
    'Authorization': 'Bearer $token',
    'X-CSRFToken': csrfToken,
  };
  var response = await http.get(uri, headers: headers);
  print(response.body);
  var data = json.decode(response.body);
  print(data);

  if (response.statusCode == 200) {
    print("Successful");
    return data;
  } else {
    print("Some error occured. Access is denied.");
  }
}
