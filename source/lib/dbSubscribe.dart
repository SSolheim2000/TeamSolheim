import 'package:TeamSolheim/home.dart';
import 'package:TeamSolheim/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBServiceSubscribes {
  final String uid = Home.myUID;
  DBServiceSubscribes({uid});
  // collection reference
  final CollectionReference subscribesCollection = Firestore.instance.collection('MySubscribes');

//******************************************************************************
  Future initializeSubscribes(
      bool subscribeSubscribe,
      ) async {
    return await subscribesCollection.document(Home.myUID).setData({
      'Initialize' : subscribeSubscribe,
    });
  }
//******************************************************************************
  Future updateSubscribes(
    bool subscribeSubscribe,
    String subscribeCategory,
  ) async {
    return await subscribesCollection.document(Home.myUID).updateData({
      '${Home.subscribeUpdateID}' : subscribeSubscribe,
      '${Home.subscribeUpdateID}Category'  : subscribeCategory
    });
  }
//******************************************************************************
  // get user doc stream
  Stream<MySubscribes> get subscribes {
    print('************ Ran MySubscribes Stream');
    return subscribesCollection.document(Home.myUID).snapshots()
        .map(_subscribesFromSnapshot);
  }
//******************************************************************************
  // Subscribes from snapshot
  MySubscribes _subscribesFromSnapshot(DocumentSnapshot snapshot) {
    print('************ Ran MySubscribes Snapshot');
    Home.snapSubscribes = snapshot.data;
    return null;
  }
}