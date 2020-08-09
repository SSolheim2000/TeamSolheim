import 'package:TeamSolheim/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBServiceUserData {
  final String uid;
  DBServiceUserData({this.uid});
  // collection reference
  final CollectionReference userDataCollection = Firestore.instance.collection('UserData');

  Future updateUserData(
    int    dbLevel,
    String maritalStatus,
    String firstName1,
    String firstName2,
    String lastName,
    String birthMonth1,
    int    birthDate1,
    String birthMonth2,
    int    birthDate2,
    String kids,
    String church,
    String gender,
  ) async {
    return await userDataCollection.document(uid).updateData({
      'maritalStatus' : maritalStatus,
      'firstName1'    : firstName1,
      'firstName2'    : firstName2,
      'lastName'      : lastName,
      'birthMonth1'   : birthMonth1,
      'birthDate1'    : birthDate1,
      'birthMonth2'   : birthMonth2,
      'birthDate2'    : birthDate2,
      'kids'          : kids,
      'church'        : church,
      'gender'        : gender,
    });
  }

  Future updateGoogleData(
    String myUID,
    String displayName,
    String phoneNumber,
    String photoUrl,
    String login,
  ) async {

    return await userDataCollection.document(uid).updateData({
      'myUID'       : myUID,
      'displayName' : displayName,
      'phoneNumber' : phoneNumber,
      'photoUrl'    : photoUrl,
      'login'       : login,
    });
  }

  // get user doc stream
  Stream<UserData> get userData {
    print('***************** Stream for User Data  Ran ********************');
    return userDataCollection.document(uid).snapshots()
        .map(_userDataFromSnapshot);
  }

  // UserData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    print('***************** Snapshot for UserData Ran ********************');
    return UserData(
      uid:  uid,
      maritalStatus: snapshot.data['maritalStatus'],
      firstName1: snapshot.data['firstName1'],
      firstName2: snapshot.data['firstName2'],
      lastName: snapshot.data['lastName'],
      birthMonth1: snapshot.data['birthMonth1'],
      birthDate1: snapshot.data['birthDate1'],
      birthMonth2: snapshot.data['birthMonth2'],
      birthDate2: snapshot.data['birthDate2'],
      kids: snapshot.data['kids'],
      church: snapshot.data['church'],
      gender: snapshot.data['gender'],
    );
  }
}