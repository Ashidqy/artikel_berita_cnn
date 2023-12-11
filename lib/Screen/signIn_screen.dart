import 'package:article/Screen/bottom_navigation.dart';
import 'package:article/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:article/reusable_widget/reusable.dart';
import 'package:article/Screen/sigUp_screen.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextcontroller = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void dispose() {
    _emailTextcontroller.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  Future<String?> getUsername(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user_cnn')
              .where('email', isEqualTo: email)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0]['username'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting username: $e');
      return null;
    }
  }

  Future<String?> gettopik(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user_cnn')
              .where('email', isEqualTo: email)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0]['topik_favorit'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting topik: $e');
      return null;
    }
  }

  Future<String?> getjk(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user_cnn')
              .where('email', isEqualTo: email)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0]['jenis_kelamin'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting jk: $e');
      return null;
    }
  }

  void login() async {
    String email = _emailTextcontroller.text;
    String password = _passwordTextController.text;

    User? user = (await _authService.loginwithEmailandPassword(
        email, password, context)) as User?;

    if (user != null) {
      String? username = await getUsername(email);
      String? topik = await gettopik(email);
      String? jk = await getjk(email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login Success"),
        backgroundColor: Colors.green,
      ));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationBarExampleApp(
            username: username ?? email,
            topik: topik ?? email,
            jk: jk ?? email,
            email: email,
          ),
        ),
      );
      print(username);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.purpleAccent],
                begin: Alignment.center,
                end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/cnn.png"),
                SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter Email", Icons.person_2_outlined, false,
                    _emailTextcontroller),
                SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                SizedBox(
                  height: 20,
                ),
                SignInSignButton(context, true, () {
                  login();
                }),
                signUpOption(),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have account?",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
