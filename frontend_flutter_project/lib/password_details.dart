import 'package:flutter/material.dart';

class PasswordDetailsPage extends StatelessWidget {
  final passwordItem passwordItem;

  PasswordDetailsPage({required this.passwordItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${passwordItem.title}'),
            Text('Username: ${passwordItem.username}'),
            Text('Password: ${passwordItem.password}'),
            Text('Website: ${passwordItem.website}'),
            Text('Notes: ${passwordItem.notes}'),
          ],
        ),
      ),
    );
  }
}
