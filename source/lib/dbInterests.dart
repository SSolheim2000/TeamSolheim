import 'package:TeamSolheim/home.dart';
import 'package:TeamSolheim/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBServiceInterests {
  final String uid = Home.myUID;
  DBServiceInterests({uid});
  // collection reference
  final CollectionReference interestsCollection = Firestore.instance.collection('MyInterests');

  //******************************************************************************
  Future initializeInterests(
      bool interestSubscribe,
      ) async {
    return await interestsCollection.document(Home.myUID).setData({
      'Initialize' : interestSubscribe,
    });
  }

//******************************************************************************
  Future updateInterests(
    bool interestSubscribe,
    String interestCategory,
  ) async {
    return await interestsCollection.document(Home.myUID).updateData({
      '${Home.interestUpdateID}' : interestSubscribe,
      '${Home.interestUpdateID}Category'  : interestCategory
    });
  }
//******************************************************************************
  // get user doc stream
  Stream<MyInterests> get interests {
    print('************ Ran MyInterests Stream');
    return interestsCollection.document(Home.myUID).snapshots()
        .map(_interestsFromSnapshot);
  }
//******************************************************************************
  // Interests from snapshot
  MyInterests _interestsFromSnapshot(DocumentSnapshot snapshot) {
    print('************ Ran MyInterests Snapshot');
    Home.snapInterests = snapshot.data;
    return null;
  }

}