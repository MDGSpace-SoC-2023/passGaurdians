import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:passGuard/api_connection/auth_api.dart';

Future Create(String title, String username, String password, String website,
    String details, String token) async {
  var uriListCreate =
      Uri.parse("http://127.0.0.1:8000/passwordStorageApp/create/");
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
        'Authorization': 'Token $token',
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

Future Update(String title, String username, dynamic password, String website,
    String details, String token) async {
  var pk = getpk();
  var uriUpdate = Uri.parse("http://127.0.0.1:8000/update/$pk");
  String csrfToken = await getCsrfToken();
  print(token);
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
        'Authorization': 'Token $token',
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
      Uri.parse("http://127.0.0.1:8000/passwordStorageApp/create/");

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

  if (response.statusCode == 200) {
    print("Successful");
    return data;
  } else {
    print("Some error occured. Access is denied.");
  }
}

Future getpk() async {
  var uri = Uri.parse("http://127.0.0.1:8000/passwordStorageApp/pk/");
  var response = await http.get(uri);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return data;
  } else {
    print("Some error occured");
    return;
  }
}
