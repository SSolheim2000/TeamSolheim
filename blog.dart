import 'package:TeamSolheim/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogPage extends StatefulWidget {
  @override
  BlogPageState createState() {
    return BlogPageState();
  }
}

class BlogPageState extends State<BlogPage> {
  String id;
  final db = Firestore.instance;
  String name;
  static String url = '';

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 60.0, width: 500.0,
              child: RaisedButton(
                color: Home.buttonBG,
                onPressed: () async {
                  url = '${doc.data['blogLink']}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                  print(doc.data['blogLikes']);
                  updateData(doc);
                  print(doc.data['blogLikes']);
                  setState(() {});
                },
                child: AutoSizeText(
                  '${doc.data['blogTitle']}',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Text(
                    'Likes: ${doc.data['blogLikes']}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(flex: 4,child: SizedBox(width: 100.0)),
                Expanded(
                  flex: 10,
                  child: Text(
                    'Date: ${doc.data['blogDate']}',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${Home.title}'),
          backgroundColor: Home.appbarBG,
          elevation: 0.0,
        ),
      body: ListView(
        padding: EdgeInsets.all(5),
        children: <Widget>[

          StreamBuilder<QuerySnapshot>(
            stream: db.collection('Blogs').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data.documents.map((doc) => buildItem(doc)).toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('Blogs').document(id).get();
    print(snapshot.data['name']);
  }

  void updateData(DocumentSnapshot doc) async {
//    await db.collection('Blogs').document(doc.documentID).get();
//    print('DB value ${doc.data['blogLikes']}');
    doc.data['blogLikes']++;
    await db.collection('Blogs').document(doc.documentID).updateData({'blogLikes': doc.data['blogLikes']});
  }
}