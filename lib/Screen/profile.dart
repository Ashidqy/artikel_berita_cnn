import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String username;
  final String email;
  final String jenisKelamin;
  final String topikFavorit;
  Profile({
    super.key,
    required this.username,
    required this.email,
    required this.jenisKelamin,
    required this.topikFavorit,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String imageUrl = '';
  @override
  void initState() {
    super.initState();
    // Pada initState, atur imageUrl berdasarkan nilai widget.jk
    if (widget.jenisKelamin == 'Male') {
      imageUrl = 'https://cdn-icons-png.flaticon.com/512/5556/5556468.png';
    } else if (widget.jenisKelamin == 'Female') {
      imageUrl = 'https://cdn-icons-png.flaticon.com/512/4086/4086577.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text("Profile User"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.purpleAccent],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter)),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: Container(
                    height: 200,
                    width: 200,
                    color: Colors.white,
                    child: Image.network(imageUrl),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                viewText(context, 'Username', widget.username),
                SizedBox(
                  height: 15,
                ),
                viewText(context, 'Email', widget.email),
                SizedBox(
                  height: 15,
                ),
                viewText(context, 'Jenis Kelamin', widget.jenisKelamin),
                SizedBox(
                  height: 15,
                ),
                viewText(context, 'Topik Favorit', widget.topikFavorit)
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Column viewText(BuildContext context, String upper, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          upper,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                content,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.9)),
              )
            ],
          ),
          height: 50,
          width: MediaQuery.of(context).size.width - 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.3)),
        )
      ],
    );
  }
}
