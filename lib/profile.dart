import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'home_page.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  final User? user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      return false;
    },

      child: Scaffold(
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
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.logout, color: Colors.green,),
                onPressed: () async {
                  await AuthService().signOut(context);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false,
                  );
                },

              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: (user?.photoURL != null)
                    ? NetworkImage(user!.photoURL!)
                    : null, // If there's a photoURL, use it as background image
                child: (user?.photoURL == null)
                    ? Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white,
                )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              user?.displayName ?? '',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.email,
                  size: 16,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 4),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
