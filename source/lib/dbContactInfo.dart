import 'package:TeamSolheim/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBServiceContactInfo {
  final String uid;
  DBServiceContactInfo({this.uid});
  // collection reference
  final CollectionReference contactInfoCollection = Firestore.instance.collection('ContactInfo');

  Future updateContactInfo(
    String email0,
    String email1,
    String email2,
    String primaryEmail,
    String priAddress1,
    String priAddress2,
    String priCity,
    String priState,
    String priZip,
    String phone0,
    String phone1,
    String phone2,
    String primaryPhone,
  ) async {
    print('TEST 2 - {$uid}');
    return await contactInfoCollection.document(uid).setData({
      'email0'          : email0,
      'email1'          : email1,
      'email2'          : email2,
      'primaryEmail'    : primaryEmail,
      'priAddress1'     : priAddress1,
      'priAddress2'     : priAddress2,
      'priCity'         : priCity,
      'priState'        : priState,
      'priZip'          : priZip,
      'phone0'          : phone0,
      'phone1'          : phone1,
      'phone2'          : phone2,
      'primaryPhone'    : primaryPhone,
    });
  }

  // get user doc stream
  Stream<ContactInfo> get contactInfo {
    return contactInfoCollection.document(uid).snapshots()
        .map(_contactInfoFromSnapshot);
  }

  // ContactInfo from snapshot
  ContactInfo _contactInfoFromSnapshot(DocumentSnapshot snapshot1) {
    return ContactInfo(
      uid: uid,
      email0: snapshot1.data['email0'],
      email1: snapshot1.data['email1'],
      email2: snapshot1.data['email2'],
      primaryEmail: snapshot1.data['primaryEmail'],
      priAddress1: snapshot1.data['priAddress1'],
      priAddress2: snapshot1.data['priAddress2'],
      priCity: snapshot1.data['priCity'],
      priState: snapshot1.data['priState'],
      priZip: snapshot1.data['priZip'],
      phone0: snapshot1.data['phone0'],
      phone1: snapshot1.data['phone1'],
      phone2: snapshot1.data['phone2'],
      primaryPhone: snapshot1.data['primaryPhone'],
    );
  }
}