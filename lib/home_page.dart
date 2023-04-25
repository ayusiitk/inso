import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';
import 'profile.dart';

class HomePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 1,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            children: [
              TextSpan(
                text: 'I',
                style: TextStyle(color: Colors.green),
              ),
              TextSpan(
                text: 'n',
                style: TextStyle(color: Colors.red),
              ),
              TextSpan(
                text: 'S',
                style: TextStyle(color: Colors.blue),
              ),
              TextSpan(
                text: 'o',
                style: TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,

        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.green,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(user: user),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to your Home Page',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

    );
  }
}
