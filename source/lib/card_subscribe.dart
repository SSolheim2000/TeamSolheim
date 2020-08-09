import 'package:TeamSolheim/dbSubscribe.dart';
import 'package:TeamSolheim/home.dart';
import 'package:TeamSolheim/user.dart';
import 'package:TeamSolheim/authsvc.dart';
import 'package:TeamSolheim/dbStats.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscribePage extends StatefulWidget {
  @override
  SubscribePageState createState() {
    return SubscribePageState();
  }
}

class SubscribePageState extends State<SubscribePage> {
  final String uid;                                                             // MySubscribes data
  SubscribePageState({this.uid});                                               // MySubscribes data
  String id;
  final db = Firestore.instance;
  final dbSubscribes = Firestore.instance.collection('Subscribes');
  final dbMySubscribes = Firestore.instance.collection('MySubscribes');
  String name;
  bool _subscribeUpdate;
  String _subscribeCategory = 'SomethingNew';
  static String url = '';
  Color bgColor;

  Card buildItem(DocumentSnapshot doc) {
    if (Home.myUID == null) {
      print('You need to login!!');
      AuthService().signOutGoogle();
      AuthService().signOutFirebase();
    } else {

      Home.subscribeID = doc.documentID;
      _subscribeCategory = doc.data['subscribeKeyword'];
      try {                                                                     // This creates the UID folder if it doesn't already exist in the MyInterests DB collection
        print(Home.snapSubscribes['Initialize']);
      } catch (e) {
        // intentionally left empty.
        initializeData(doc);
      }
      if (Home.snapSubscribes[Home.subscribeID] == null) {
        _subscribeUpdate = false;
        bgColor = Colors.lime[200];
        Home.subscribeUpdateID = doc.documentID;
        updateData(doc);

      } else {
        Home.mapSubscribes[doc.documentID] = Home.snapSubscribes['${doc.documentID}'];
        if (Home.snapSubscribes['${doc.documentID}']) {
          bgColor = Colors.lime[600];
          _subscribeUpdate = true;
        } else {
          bgColor = Colors.lime[200];
          _subscribeUpdate = false;
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
                  Home.subscribeUpdateID = doc.documentID;
                  _subscribeUpdate   = Home.snapSubscribes[Home.subscribeUpdateID];
                  if (Home.snapSubscribes[Home.subscribeUpdateID] == null) {_subscribeUpdate = false;}
                  _subscribeCategory = doc.data['subscribeKeyword'];
                  updateData(doc);
                  setState(() {});
                },
                child: AutoSizeText(
                  '${doc.data['subscribeTitle']}',
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
                  '${doc.data['subscribeDescription']}',
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
                Expanded(flex: 3,child: SizedBox(width: 100.0)),
                Expanded(
                  flex: 10,
                  child: Text(
                    '${doc.data['subscribeKeyword']}',
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
              Home.category = 'Subscribes';
              Stats stats = statsSnapshot.data;
              Home.stats = stats;
              return StreamBuilder<MySubscribes>(
                //stream: DBServiceUserData(uid: user.uid).userData,
                stream: DBServiceSubscribes(uid: Home.myUID).subscribes,
                builder: (context, mySnapshot) {
                  MySubscribes subscribes = mySnapshot.data;
                  Home.subscribes = subscribes;
                  return StreamBuilder<QuerySnapshot>(
                    stream: dbSubscribes.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(children: snapshot.data.documents.map((
                            doc) => buildItem(doc)).toList());
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
    await DBServiceSubscribes(uid: Home.myUID).initializeSubscribes(
      //!_SubscribeUpdate,
      true,
    );
  }
  void updateData(DocumentSnapshot doc) async {
    if(_subscribeUpdate == true) {
      print('***** Unsubscribe Likes');
      unsubscribe(doc);
    } else {
      print('***** Subscribe Likes');
      subscribe(doc);
    }
    await DBServiceSubscribes(uid: Home.myUID).updateSubscribes(
      !_subscribeUpdate,
      _subscribeCategory,
    );
  }

  void subscribe(DocumentSnapshot doc) async {
    // subscribe to the topic
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    await _firebaseMessaging.subscribeToTopic(_subscribeCategory);

    //increase like count.
    int _temp = Home.snapStats['${doc.documentID}'];
    _temp = _temp + 1;
    await db.collection('Stats').document('Subscribes').updateData({doc.documentID: _temp});
  }

  void unsubscribe(DocumentSnapshot doc) async {
    // subscribe to the topic
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    await _firebaseMessaging.unsubscribeFromTopic(_subscribeCategory);

    //increase like count.
    int _temp = Home.snapStats['${doc.documentID}'];
    _temp = _temp - 1;
    await db.collection('Stats').document('Subscribes').updateData({doc.documentID: _temp});
  }
}