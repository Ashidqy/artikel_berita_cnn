import 'package:article/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:article/reusable_widget/reusable.dart';
import 'package:article/Screen/signIn_screen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextcontroller = TextEditingController();
  TextEditingController _userNameTextcontroller = TextEditingController();
  String selectedCategory = 'Nasional';
  String selectedJK = 'Male';
  @override
  void dispose() {
    _emailTextcontroller.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  void register() async {
    String email = _emailTextcontroller.text;
    String password = _passwordTextController.text;
    User? user =
        await _authService.signwithEmaildanPassword(email, password, context);
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User is Successfully Created"),
        backgroundColor: Colors.green,
      ));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Cannot Create User"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> signUpAndAddData(
      String email, String password, String username) async {
    try {
      // Step 1: Create a user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Get the user ID from the authentication result
      String userId = userCredential.user!.uid;

      // Step 3: Add user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'username': username,
        'email': email,
        // You can add more fields as needed
      });

      print('User signed up and data added to Firestore successfully!');
    } catch (e) {
      print('Error signing up and adding data: $e');
    }
  }

  Future<void> addUser() {
    CollectionReference users =
        FirebaseFirestore.instance.collection('user_cnn');

    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'username': _userNameTextcontroller.text, // John Doe
          'email': _emailTextcontroller.text, // Stokes and Sons
          'password': _passwordTextController.text, // 42
          'topik_favorit': selectedCategory,
          'jenis_kelamin': selectedJK
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
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
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Username", Icons.person_2_outlined,
                    false, _userNameTextcontroller),
                SizedBox(
                  height: 20,
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
                DropdownButton_Topik(),
                SizedBox(
                  height: 20,
                ),
                DropdownButton_JK(),
                SizedBox(
                  height: 20,
                ),
                SignInSignButton(context, false, () {
                  register();
                  addUser();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container DropdownButton_Topik() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white.withOpacity(0.3),
      ),
      child: DropdownButton<String>(
        value: selectedCategory,
        isExpanded: true,
        onChanged: (String? newValue) {
          setState(() {
            selectedCategory = newValue!;
          });
        },
        items: <String>[
          'Nasional',
          'Internasional',
          'Ekonomi',
          'Olahraga',
          'Teknologi',
          'GayaHidup'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
        style: TextStyle(color: Colors.white.withOpacity(0.9)),
        underline: Container(), // Remove the underline
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
        dropdownColor: Colors.white.withOpacity(0.3),
      ),
    );
  }

  Container DropdownButton_JK() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white.withOpacity(0.3),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedJK,
          onChanged: (String? newValue) {
            setState(() {
              selectedJK = newValue!;
            });
          },
          items: <String>['Male', 'Female']
              .map<DropdownMenuItem<String>>((String value) {
            String imageUrl = '';
            if (value == 'Male') {
              imageUrl =
                  'https://cdn-icons-png.flaticon.com/512/5556/5556468.png';
            } else if (value == 'Female') {
              imageUrl =
                  'https://cdn-icons-png.flaticon.com/512/4086/4086577.png';
            }

            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Image.network(
                    imageUrl,
                    height: 24,
                    width: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    value,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }).toList(),
          style: TextStyle(color: Colors.white.withOpacity(0.9)),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
          dropdownColor: Colors.white.withOpacity(0.3),
          isExpanded: true,
        ),
      ),
    );
  }
}
