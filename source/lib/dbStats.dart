import 'package:TeamSolheim/home.dart';
import 'package:TeamSolheim/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBServiceStats {
  final String uid = Home.statID;
  DBServiceStats({uid});
  // collection reference
  final CollectionReference statsCollection = Firestore.instance.collection('Stats');

  //******************************************************************************
  Future initializeStats(
      bool interestSubscribe,
      ) async {
    return await statsCollection.document(Home.category).setData({
      'Initialize' : interestSubscribe,
    });
  }

//******************************************************************************
  Future updateStats(
    int statValue,
    String statCategory,
  ) async {
    return await statsCollection.document(Home.category).updateData({
      '${Home.statID}' : statValue,
      '${Home.statID}Category'  : statCategory
    });
  }
//******************************************************************************
  // get user doc stream
  Stream<Stats> get stats {
    print('************ Ran Stats Stream');
    return statsCollection.document(Home.category).snapshots()
        .map(_statsFromSnapshot);
  }
//******************************************************************************
  // Stats from snapshot
  Stats _statsFromSnapshot(DocumentSnapshot snapshot) {
    print('************ Ran Stats Snapshot');
    Home.snapStats = snapshot.data;
    return null;
  }

}