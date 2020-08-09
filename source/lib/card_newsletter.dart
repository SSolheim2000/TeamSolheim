import 'package:TeamSolheim/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:TeamSolheim/dbStats.dart';
import 'package:TeamSolheim/user.dart';

class NewsletterPage extends StatefulWidget {
  @override
  NewsletterPageState createState() {
    return NewsletterPageState();
  }
}

class NewsletterPageState extends State<NewsletterPage> {
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
                  url = '${doc.data['newsletterLink']}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                  updateData(doc);
                  setState(() {});
                },
                child: AutoSizeText(
                  '${doc.data['newsletterTitle']}',
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
                    'Likes: ${Home.snapStats['${doc.documentID}']}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(flex: 4,child: SizedBox(width: 100.0)),
                Expanded(
                  flex: 10,
                  child: Text(
                    'Date: ${doc.data['newsletterDate']}',
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
          StreamBuilder<Stats>(
            stream: DBServiceStats(uid: Home.statID).stats,
            builder: (context, statsSnapshot){
              Home.category = 'Newsletters';
              Stats stats = statsSnapshot.data;
              Home.stats = stats;
              return StreamBuilder<QuerySnapshot>(
                stream: db.collection('Newsletters').snapshots(),
                builder: (context, snapshot) {
                  print('Starting Newsletter Stream *****************************');
                  if (snapshot.hasData) {
                    return Column(children: snapshot.data.documents.map((doc) => buildItem(doc)).toList());
                  } else {
                    return SizedBox();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

//  void readData() async {
//    DocumentSnapshot snapshot = await db.collection('Newsletters').document(id).get();
//    print(snapshot.data['name']);
//  }

  void updateData(DocumentSnapshot doc) async {
    int _temp = Home.snapStats['${doc.documentID}'];
    _temp = _temp + 1;
    await db.collection('Stats').document('Newsletters').updateData({doc.documentID: _temp});
  }
}