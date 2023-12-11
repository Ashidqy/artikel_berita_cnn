import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class DetailPage extends StatefulWidget {
  final String avatar;
  final String foto;
  final String title;
  final String author;
  final String content;
  final String pubdate;

  DetailPage(
      {required this.avatar,
      required this.foto,
      required this.title,
      required this.author,
      required this.content,
      required this.pubdate});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class Article {
  final String detail;

  const Article({required this.detail});
}

class _DetailPageState extends State<DetailPage> {
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    getWebsiteData(widget.content);
  }

  Future<void> getWebsiteData(String link) async {
    final url = Uri.parse(link);
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final paragraphs = html
        .querySelectorAll('.detail-text > p') // Select only <p> elements
        .map((element) => element.innerHtml.trim())
        .toList();

    print('Count: ${paragraphs.length}');
    setState(() {
      articles = List.generate(
          paragraphs.length, (index) => Article(detail: paragraphs[index]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("CNN"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.pinkAccent, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        widget.author,
                        style:
                            TextStyle(color: Colors.pinkAccent, fontSize: 14),
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.title,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: double.maxFinite,
                height: 250,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.foto), fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.avatar,
                    ),
                    maxRadius: 20,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CNN",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.pubdate,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              //HTML view
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    String justifyCss = 'text-align: justify;';
                    return HtmlWidget(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                        '<div style="$justifyCss">${articles[index].detail}</div>');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
