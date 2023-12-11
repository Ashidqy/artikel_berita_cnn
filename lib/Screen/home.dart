import 'dart:convert';
import 'package:article/Screen/detail_page.dart';
import 'package:article/Screen/profile.dart';
import 'package:article/Screen/signIn_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:article/model/article_berita.dart';

class Home extends StatefulWidget {
  final String username;
  final String topik;
  final String jk;
  final String email;
  Home(
      {required this.username,
      required this.topik,
      required this.jk,
      required this.email});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  String imageUrl = '';
  @override
  void initState() {
    super.initState();
    // Pada initState, atur imageUrl berdasarkan nilai widget.jk
    if (widget.jk == 'Male') {
      imageUrl = 'https://cdn-icons-png.flaticon.com/512/5556/5556468.png';
    } else if (widget.jk == 'Female') {
      imageUrl = 'https://cdn-icons-png.flaticon.com/512/4086/4086577.png';
    }
  }

  Future<ArtikelBeritaData> fetchNews1(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      return ArtikelBeritaData.fromJson(data);
    } else {
      throw Exception('Failed to load news');
    }
  }

  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());

// output: 2021-08-27

  String cdate1 = DateFormat("EEEEE, dd, yyyy").format(DateTime.now());
// output: Friday, 27, 2021
  String cdate2 = DateFormat("EEE dd, MMMM yyyy").format(DateTime.now());
  //output:  August, 27, 2021

  String cdate3 = DateFormat("MMM, EEE, yyyy").format(DateTime.now());
// output:  Aug, Fri, 2021
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return SafeArea(
      child: Scaffold(
        body: BodyHome(_tabController, widget.topik.toUpperCase()),
      ),
    );
  }

  Padding BodyHome(TabController _tabController, String jenis) {
    String Favorit = jenis.toLowerCase();
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopHeader(
                cdate2: cdate2,
                username: widget.username,
                topik: widget.topik,
                jenisKelamin: widget.jk,
                email: widget.email,
                imageurl: imageUrl,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Breaking News CNN",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              TrendingCard3(
                  'https://api-berita-indonesia.vercel.app/cnn/terbaru/'),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Favorit Anda ",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: kategori(
                  "https://api-berita-indonesia.vercel.app/cnn/$Favorit/",
                  10,
                  "$jenis",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<ArtikelBeritaData> kategori(
      String url, int jumlah, String kategori) {
    return FutureBuilder<ArtikelBeritaData>(
      future: fetchNews1(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          var articles = snapshot.data;
          return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: jumlah,
              itemBuilder: (context, index) {
                var post = articles!.posts![index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                                  avatar: articles.image!,
                                  foto: post.thumbnail!,
                                  title: post.title!,
                                  content: post.link!,
                                  author: kategori,
                                  pubdate: post.pubDate!,
                                )));
                  },
                  child: Card(
                    shadowColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    // Define how the card's content should be clipped
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      color: Color.fromARGB(255, 255, 175, 207),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9)),
                                image: DecorationImage(
                                    image: NetworkImage(post.thumbnail!),
                                    scale: 1,
                                    fit: BoxFit.cover)),
                            //
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  kategori,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  post.title!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  post.pubDate!,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
      },
    );
  }

  Container TrendingCard3(String newsurl) {
    return Container(
      width: double.maxFinite,
      height: 300,
      child: FutureBuilder<ArtikelBeritaData>(
        future: fetchNews1(newsurl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final articles = snapshot.data;
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  var post = articles!.posts![index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(
                                    avatar: articles.image!,
                                    foto: post.thumbnail!,
                                    title: post.title!,
                                    content: post.link!,
                                    author: "Terbaru",
                                    pubdate: post.pubDate!,
                                  )));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            image: DecorationImage(
                                image: NetworkImage(post.thumbnail!),
                                fit: BoxFit.cover)),
                        width: 260,
                        child: Stack(
                          children: [
                            Positioned(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.pinkAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        "Terbaru",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 240,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    color: Colors.white60,
                                    child: Text(
                                      post.title!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                              bottom: 10,
                              left: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }

  Column BackgroundHome() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 249, 154, 185),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50))),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(50))),
            ),
          ),
        ),
      ],
    );
  }
}

class TopHeader extends StatelessWidget {
  const TopHeader(
      {super.key,
      required this.cdate2,
      required this.username,
      required this.topik,
      required this.jenisKelamin,
      required this.email,
      required this.imageurl});

  final String cdate2;
  final String username;
  final String topik;
  final String email;
  final String jenisKelamin;
  final String imageurl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 5,
          shadowColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  Colors.pinkAccent, // Pink

                  Colors.purpleAccent, // Blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(
                                username: username,
                                email: email,
                                jenisKelamin: jenisKelamin,
                                topikFavorit: topik),
                          ));
                    },
                    child: Container(
                      width: 35.0, // Adjust the width as needed
                      height: 35.0, // Adjust the height as needed
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            '$imageurl', // Replace with your image URL
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hello!",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            )),
                        Text(
                          "$username",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 228, 230, 233)),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _showLogoutConfirmationDialog(context);
                      },
                      icon: Icon(Icons.logout))
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "$cdate2",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Lakukan logout di sini
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SignInScreen())); // Tutup dialog setelah logout
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
