import 'package:flutter/material.dart';
import 'package:loginuicolors/screens/password_details.dart';
import 'package:loginuicolors/api_connection/passwordStorage_api.dart';

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
    fetchdata();
  }

  void fetchdata() async {
    List data = await ListPasswords();
    data.forEach(
      (pass) {
        PasswordItem p = PasswordItem(
          title: pass['title'],
          username: pass['username'],
          password: pass['password'],
          website: pass['website'],
          notes: pass['details'],
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
                    titleController.text,
                    usernameController.text,
                    passwordController.text,
                    websiteController.text,
                    notesController.text)) {
                  setState(
                    () {
                      passwordList.add(
                        PasswordItem(
                          title: titleController.text,
                          username: usernameController.text,
                          password: passwordController.text,
                          website: websiteController.text,
                          notes: notesController.text,
                        ),
                      );
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
    return Scaffold(
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
