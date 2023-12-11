import 'package:article/Screen/detail_page.dart';
import 'package:article/model/article_berita.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KategoriBeritaCNN extends StatefulWidget {
  const KategoriBeritaCNN({super.key});

  @override
  State<KategoriBeritaCNN> createState() => _KategoriBeritaCNNState();
}

class _KategoriBeritaCNNState extends State<KategoriBeritaCNN> {
  Future<ArtikelBeritaData> fetchNews1(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      return ArtikelBeritaData.fromJson(data);
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.pink,
        title: Text("Kategori Berita"),
      ),
      body: DefaultTabController(
          length: 5,
          child: Column(
            children: [
              Material(
                child: Container(
                  height: 70,
                  color: Colors.white,
                  child: TabBar(
                      isScrollable: true,
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      unselectedLabelColor: Colors.pink,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.pinkAccent),
                      tabs: [
                        Tab(
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 1, color: Colors.pinkAccent),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Nasional"),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 1, color: Colors.pinkAccent),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("International"),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 1, color: Colors.pinkAccent),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Ekonomi"),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 1, color: Colors.pinkAccent),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Olahraga"),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 1, color: Colors.pinkAccent),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Teknologi"),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              Expanded(
                  child: Container(
                color: Color.fromARGB(255, 255, 158, 170),
                child: TabBarView(children: [
                  TabbarView(
                      "https://api-berita-indonesia.vercel.app/cnn/nasional/",
                      "Nasional"),
                  TabbarView(
                      "https://api-berita-indonesia.vercel.app/cnn/internasional/",
                      "Internasional"),
                  TabbarView(
                      "https://api-berita-indonesia.vercel.app/cnn/ekonomi/",
                      'Ekonomi'),
                  TabbarView(
                      "https://api-berita-indonesia.vercel.app/cnn/olahraga/",
                      "Olahraga"),
                  TabbarView(
                      "https://api-berita-indonesia.vercel.app/cnn/teknologi/",
                      "Teknologi"),
                ]),
              ))
            ],
          )),
    );
  }

  FutureBuilder<ArtikelBeritaData> TabbarView(String url, String kategori) {
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
              itemCount: 20,
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    // Define how the card's content should be clipped
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      color: Color.fromARGB(255, 255, 255, 255),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 100,
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  kategori,
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  post.title!,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  post.pubDate!,
                                  style: TextStyle(fontSize: 10),
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
}
