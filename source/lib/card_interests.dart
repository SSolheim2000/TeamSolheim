import 'package:TeamSolheim/dbInterests.dart';
import 'package:TeamSolheim/home.dart';
import 'package:TeamSolheim/user.dart';
import 'package:TeamSolheim/authsvc.dart';
import 'package:TeamSolheim/dbStats.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InterestPage extends StatefulWidget {
  @override
  InterestPageState createState() {
    return InterestPageState();
  }
}

class InterestPageState extends State<InterestPage> {
  final String uid;                                                             // MyInterests data
  InterestPageState({this.uid});                                                // MyInterests data
  String id;
  final db = Firestore.instance;
  final dbInterests = Firestore.instance.collection('Interests');
  final dbMyInterests = Firestore.instance.collection('MyInterests');
  String name;
  bool _interestUpdate;
  String _interestCategory = 'SomethingNew';
  static String url = '';
  Color bgColor;

  Card buildItem(DocumentSnapshot doc) {
    if (Home.myUID == null) {
      print('You need to login!!');
      AuthService().signOutGoogle();
      AuthService().signOutFirebase();
    } else {
      _interestCategory = doc.data['interestKeyword'];
      Home.interestID = doc.documentID;
      try {                                                                     // This creates the UID folder if it doesn't already exist in the MyInterests DB collection
        print(Home.snapInterests['Initialize']);
      } catch (e) {
        // intentionally left empty.
        initializeData(doc);
      }

      if (Home.snapInterests[Home.interestID] == null) {
        _interestUpdate = false;
        bgColor = Colors.lime[200];
        Home.interestUpdateID = doc.documentID;
        updateData(doc);

      } else {
        Home.mapInterests[doc.documentID] = Home.snapInterests['${doc.documentID}'];
        if (Home.snapInterests['${doc.documentID}']) {
          bgColor = Colors.lime[600];
          _interestUpdate = true;
        } else {
          bgColor = Colors.lime[200];
          _interestUpdate = false;
        }
      }
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 60.0, width: 500.0,
              child: RaisedButton(
                color: bgColor,
                onPressed: () async {
                  Home.interestUpdateID = doc.documentID;
                  _interestUpdate   = Home.snapInterests[Home.interestUpdateID];
                  if (Home.snapInterests[Home.interestUpdateID] == null) {_interestUpdate = false;}
                  _interestCategory = doc.data['interestKeyword'];
                  updateData(doc);
                  setState(() {});
                },
                child: AutoSizeText(
                  '${doc.data['interestTitle']}',
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
              color: bgColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  '${doc.data['interestDescription']}',
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
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(flex: 4,child: SizedBox(width: 100.0)),
                Expanded(
                  flex: 10,
                  child: Text(
                    '${doc.data['interestKeyword']}',
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
              Home.category = 'Interests';
              Stats stats = statsSnapshot.data;
              Home.stats = stats;
              return StreamBuilder<MyInterests>(
                //stream: DBServiceUserData(uid: user.uid).userData,
                stream: DBServiceInterests(uid: Home.myUID).interests,
                builder: (context, mySnapshot) {
                  MyInterests interests = mySnapshot.data;
                  Home.interests = interests;
                  return StreamBuilder<QuerySnapshot>(
                    stream: dbInterests.snapshots(),
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
              );
            },
          ),
        ],
      ),
    );
  }

  void initializeData(DocumentSnapshot doc) async {
    await DBServiceInterests(uid: Home.myUID).initializeInterests(
      //!_interestUpdate,
      true,
    );
  }

  void updateData(DocumentSnapshot doc) async {
    if(_interestUpdate == true) {
      print('***** Unsubscribe Likes');
      unsubscribe(doc);
    } else {
      print('***** Subscribe Likes');
      subscribe(doc);
    }
    await DBServiceInterests(uid: Home.myUID).updateInterests(
      !_interestUpdate,
      _interestCategory,
    );
  }

  void subscribe(DocumentSnapshot doc) async {
    // subscribe to the topic
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    await _firebaseMessaging.subscribeToTopic(_interestCategory);

    //increase like count.
    int _temp = Home.snapStats['${doc.documentID}'];
    _temp = _temp + 1;
    await db.collection('Stats').document('Interests').updateData({doc.documentID: _temp});
  }

  void unsubscribe(DocumentSnapshot doc) async {
    // subscribe to the topic
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    await _firebaseMessaging.unsubscribeFromTopic(_interestCategory);

    //increase like count.
    int _temp = Home.snapStats['${doc.documentID}'];
    _temp = _temp - 1;
    await db.collection('Stats').document('Interests').updateData({doc.documentID: _temp});
  }
}