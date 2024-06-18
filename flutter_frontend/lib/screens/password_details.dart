import 'package:flutter/material.dart';
import 'package:passGuard/screens/homepage.dart';
import 'package:passGuard/security/auto_lock.dart';

class PasswordDetailsPage extends StatefulWidget {
  const PasswordDetailsPage({Key? key, required this.passwordItem}) : super(key: key);
  final PasswordItem passwordItem;  
  @override
  PasswordDetailsPageState createState() => PasswordDetailsPageState();
}

class PasswordDetailsPageState extends State<PasswordDetailsPage> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return AutoLock(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Password Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text('Title: ${widget.passwordItem.title}'),
              Text('Username: ${widget.passwordItem.username}'),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      showPassword
                          ? widget.passwordItem.password
                          : '*' * widget.passwordItem.password.length,
                     
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ],
              ),
              Text('Website: ${widget.passwordItem.website}'),
              Text('Notes: ${widget.passwordItem.notes}'),
            ],
          ),
        ),
      ),
    );
  }
}
