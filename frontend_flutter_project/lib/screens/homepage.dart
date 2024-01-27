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

  @override
  void initState() {
    super.initState();
    print("inside initstate");
    Future.delayed(Duration.zero, () {
      print("getting token");
      final token = ModalRoute.of(context)?.settings.arguments as dynamic;
      print(token);
      fetchdata(token);
    });
  }

  void fetchdata(dynamic token) async {
    List data = await ListPasswords(token);
    data.forEach (
      (pass) async {
        PasswordItem p = PasswordItem(
          title: await EncryptDecrypt().decryptAES(
            pass['title'],
            token,
          ),
          username:await EncryptDecrypt().decryptAES(
            pass['username'],
            token,
          ),
          password: await EncryptDecrypt().decryptAES(
            pass['password'],
            token,
          ),
          website: await EncryptDecrypt().decryptAES(
            pass['website'],
            token,
          ),
          notes: await EncryptDecrypt().decryptAES(
            pass['details'],
            token,
          ),
        );
        passwordList.add(p);
      },
    );
    setState(
      () {
        isloading = false;
      },
    );
  }

  void _showAddPasswordDialog() {
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Password'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
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
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (await Create(
                    await EncryptDecrypt().encryptAES(
                      titleController.text,
                      token,
                    ),
                    await EncryptDecrypt().encryptAES(
                      usernameController.text,
                      token,
                    ),
                    await EncryptDecrypt().encryptAES(
                      passwordController.text,
                      token,
                    ),
                    await EncryptDecrypt().encryptAES(
                      websiteController.text,
                      token,
                    ),
                    await EncryptDecrypt().encryptAES(
                      notesController.text,
                      token,
                    ),
                    token)) {
                  setState(
                    () {
                      fetchdata(token);
                    },
                  );
                  Navigator.of(context).pop();
                }
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
                    },
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddPasswordDialog,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class PasswordItem {
  String title;
  String username;
  String password;
  String website;
  String notes;

  PasswordItem(
      {required this.title,
      required this.username,
      required this.password,
      required this.website,
      required this.notes});
}

