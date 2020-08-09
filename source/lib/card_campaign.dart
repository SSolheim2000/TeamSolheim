import 'package:TeamSolheim/home.dart';
import 'package:TeamSolheim/dbStats.dart';
import 'package:TeamSolheim/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignPage extends StatefulWidget {
  @override
  CampaignPageState createState() {
    return CampaignPageState();
  }
}

class CampaignPageState extends State<CampaignPage> {
  String id;
  final db = Firestore.instance;
  String name;
  static String url = '';

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 60.0, width: 500.0,
              child: RaisedButton(
                color: Home.buttonBG,
                onPressed: () async {
                  url = '${doc.data['campaignInfo']}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                  updateData(doc);
                  setState(() {});
                },
                child: AutoSizeText(
                  '${doc.data['campaignTitle']}',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: 500,
              color: Home.buttonBG,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  '${doc.data['campaignDescription']}',
                  maxLines: 6,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: Text(
                   'Likes: ${Home.snapStats['${doc.documentID}']}',
                   //   '${doc.documentID}',
                    //'${Home.snapStats}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(flex: 2,child: SizedBox(width: 100.0)),
                Expanded(
                  flex: 10,
                  child: Text(
                    'Goal: ${doc.data['campaignGoal']}',
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
          builder: (context, statsSnapshot) {
            Home.category = 'Campaigns';
            Stats stats = statsSnapshot.data;
            Home.stats = stats;
            return StreamBuilder<QuerySnapshot>(
              stream: db.collection('Campaigns').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(children: snapshot.data.documents.map((doc) =>
                      buildItem(doc)).toList());
                } else {
                  return SizedBox();
                }
              },
            );
          },
          )
        ],
      ),
    );
  }

//  void readData() async {
//    DocumentSnapshot snapshot = await db.collection('Campaigns').document(id).get();
//    print(snapshot.data['name']);
//  }

  void updateData(DocumentSnapshot doc) async {
    int _temp = Home.snapStats['${doc.documentID}'];
    _temp = _temp + 1;
    await db.collection('Stats').document('Campaigns').updateData({doc.documentID: _temp});
  }
}