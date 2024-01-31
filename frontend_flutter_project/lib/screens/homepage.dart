import 'package:flutter/material.dart';
import 'package:passGuard/screens/password_details.dart';
import 'package:passGuard/api_connection/passwordStorage_api.dart';
import 'package:passGuard/security/HashEncrypt.dart';
import 'dart:math';
import 'package:passGuard/security/auto_lock.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHomePage> {
  List<PasswordItem> passwordList = [];
  bool isloading = true;
  bool showPassword = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    print("inside initstate");
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.delayed(Duration.zero, () {
      print("getting token");
      final token = ModalRoute.of(context)?.settings.arguments as dynamic;
      print(token);
      fetchdata(token);
    });
  }

  Future<void> fetchdata(dynamic token) async {
    List data = await ListPasswords(token);
    List<PasswordItem> decryptedPasswords = [];

    for (var pass in data) {
      PasswordItem p = await EncryptDecrypt().decryptAES(
          pass['title'],
          pass['username'],
          pass['password'],
          pass['website'],
          pass['details'],
          token);
      decryptedPasswords.add(p);
    }

    setState(() {
      passwordList = decryptedPasswords;
      isloading = false;
    });
  }

  Future<void> _addPasswordItem(PasswordItem newPassList, dynamic token) async {
    if (await Create(newPassList.title, newPassList.username,
        newPassList.password, newPassList.website, newPassList.notes, token)) {
      // Fetch the updated list of passwords
      await fetchdata(token);
    }
  }

  Future<void> _showAddPasswordDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController websiteController = TextEditingController();
    TextEditingController notesController = TextEditingController();
    final token = ModalRoute.of(context)?.settings.arguments as dynamic;
    //ignore: unused_element
    String generateRandomPassword() {
      final random = Random();
      final capitalLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      final smallLetters = "abcdefghijklmnopqrstuvwxyz";
      final specialCharacters = "!@#\$%^&*()-_+=<>?";
      final numbers = "0123456789";

      final allCharacters =
          capitalLetters + smallLetters + specialCharacters + numbers;

      String password = '';
      for (int i = 0; i < 10; i++) {
        password += allCharacters[random.nextInt(allCharacters.length)];
      }
      return password;
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Password'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                Container(
                  height: 50.0, 
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: !showPassword,
                        ),
                      ),
                      Checkbox(
                        value: showPassword,
                        onChanged: (value) {
                          setState(() {
                            showPassword = value!;
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String generatedPassword = generateRandomPassword();
                          passwordController.text = generatedPassword;
                        },
                        child: Text('Generate'),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: websiteController,
                  decoration: InputDecoration(labelText: 'Website'),
                ),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(labelText: 'Notes'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                PasswordItem PassList = await EncryptDecrypt().encryptAES(
                    titleController.text,
                    usernameController.text,
                    passwordController.text,
                    websiteController.text,
                    notesController.text,
                    token);

        await _addPasswordItem(PassList, token);

        Navigator.of(context).pop();
      },
      child: Text('Add'),
    ),
  ],
);

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AutoLock(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Password App'),
        ),
        body: isloading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: passwordList.length,
                itemBuilder: (context, index) {
                  PasswordItem item = passwordList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(passwordList[index].title[0]),
                    ),
                    title: Text(
                      passwordList[index].title,
                    ),
                    subtitle: Text(passwordList[index].username),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PasswordDetailsPage(passwordItem: item),
                        ),
                      );
                      print("rebuilding");
                    },
                  );
                },
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddPasswordDialog();
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class PasswordItem {
  String title;
  String username;
  String password;
  dynamic website;
  String notes;

  PasswordItem(
      {required this.title,
      required this.username,
      required this.password,
      required this.website,
      required this.notes});
}

class EncryptedPasswordItem {
  dynamic title;
  dynamic username;
  dynamic password;
  dynamic website;
  dynamic notes;

  EncryptedPasswordItem(
      {required this.title,
      required this.username,
      required this.password,
      required this.website,
      required this.notes});
}
