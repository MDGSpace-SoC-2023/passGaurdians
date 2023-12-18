import 'package:http/http.dart' as http;

String token = "";

Future userlogin(String email, String password) async {
  Map body = {"email": email, "password": password};

  var uri = Uri.parse("http://127.0.0.1:8000/user/accounts/login/");
  var res = await http.post(uri, body: body);

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

Future userregister(String email, String password) async {
  Map body = {"email": email, "password": password};

  var uri = Uri.parse("http://127.0.0.1:8000/user/accounts/signup/");
  var res = await http.post(uri, body: body);

  print(res.body);
  print(res.statusCode);
  if (res.statusCode == 200) {
    print("Registration Successful");
    return true;
  } else {
    print("Some Error Occured. Registration is denied");
    return false;
  }
}
