import 'package:TeamSolheim/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBServiceSubscriptions {
  final String uid;
  DBServiceSubscriptions({this.uid});
  // collection reference
  static final CollectionReference subscriptionsCollection = Firestore.instance.collection('Subscriptions');

  Future updateSubscriptions(
    String nlEmail,
    bool nlSolheim,
    bool nlCallSnail,
    bool nlCallEmail,
    bool nlMinutemenHN,
    bool nlMinutemenWorld,
    bool nlWGMAppeals,

  ) async {
    print('TEST 2 - {$uid}');
   // return await subscriptionsCollection.document(uid).updateData({'nlSolheim' :  nlSolheim});
    return await subscriptionsCollection.document(uid).setData({
      'nlEmail'           : nlEmail,
      'nlSolheim'         : nlSolheim,
      'nlCallSnail'       : nlCallSnail,
      'nlCallEmail'       : nlCallEmail,
      'nlMinutemenHN'     : nlMinutemenHN,
      'nlMinutemenWorld'  : nlMinutemenWorld,
      'nlWGMAppeals'      : nlWGMAppeals,
    });
  }

  // get user doc stream
  Stream<Subscriptions> get subscriptions {
    return subscriptionsCollection.document(uid).snapshots()
        .map(_subscriptionsFromSnapshot);
  }

  // Subscriptions from snapshot
  Subscriptions _subscriptionsFromSnapshot(DocumentSnapshot snapshot) {
    return Subscriptions(
      uid: uid,
      nlEmail: snapshot.data['nlEmail'],
      nlSolheim: snapshot.data['nlSolheim'],
      nlCallSnail: snapshot.data['nlCallSnail'],
      nlCallEmail: snapshot.data['nlCallEmail'],
      nlMinutemenHN: snapshot.data['nlMinutemenHN'],
      nlMinutemenWorld: snapshot.data['nlMinutemenWorld'],
      nlWGMAppeals: snapshot.data['nlWGMAppeals'],
    );
  }
}