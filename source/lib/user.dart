// DATABASE LEVELS (dbLevel)
//  1 - User Data (not used)
//  2 - Contact Info
//  3 - Subscriptions (future)
//  4 - Links
//  5 - Prayers from Team Solheim
//  6 - Prayers for Team Solheim
//  7 - Prayer incentive (prayer streak, how many days in a row you prayed for Team Solheim)
//  8 - Church array

import 'package:TeamSolheim/home.dart';

class User {
  final String uid;
  User({this.uid});
}

class ContactInfo {
  final String uid;
  final String email0;            // Email (husband)
  final String email1;            // Email (wife)
  final String email2;            // Email (work/other)
  final String primaryEmail;      // Indicates which is primary email (0,1,2)
  final String priAddress1;       // Primary address
  final String priAddress2;       //
  final String priCity;           //
  final String priState;          //
  final String priZip;            //
  final String phone0;            // Phone (husband)
  final String phone1;            // Phone (wife)
  final String phone2;            // Phone (work/other)
  final String primaryPhone;      // Indicates which is primary phone (0,1,2)

  ContactInfo ({this.uid, this.email0, this.email1, this.email2, this.phone0, this.phone1, this.phone2, this.priAddress1, this.priAddress2, this.priCity, this.primaryEmail, this.primaryPhone, this.priState, this.priZip});
}

class UserData {
  final String uid;
  final int    dbLevel;           // Indicates what collections have been created for the user.
  final String maritalStatus;     // array for single, married, widowed
  final String firstName1;        // husband's name if married, otherwise first name of account holder
  final String firstName2;        // wife's name
  final String lastName;          // Last name
  final String birthMonth1;       // Husband's birth month
  final int    birthDate1;        // husband's birth day
  final String birthMonth2;       // wife's birth month
  final int    birthDate2;        // wife's birthday
  final String kids;              // list of kids and ages?
  final String church;            // array of churches (TODO: Create array, database entries)
  final String gender;            // male or female

  UserData ({this.uid, this.dbLevel, this.maritalStatus, this.birthMonth1, this.birthDate1, this.birthMonth2, this.birthDate2, this.church, this.firstName1, this.firstName2, this.gender, this.kids, this.lastName});
}

class Subscriptions {
  final String uid;
  final String nlEmail;          // Email used for newsletters
  final bool nlSolheim;          // Solheim Newsletter
  final bool nlCallSnail;        // Receive The Call by Snail Mail
  final bool nlCallEmail;        // Receive The Call by email
  final bool nlMinutemenHN;      // Receive appeals for Honduras Minutemen projects
  final bool nlMinutemenWorld;   // Receive appeals for Worldwide Minutemen projects
  final bool nlWGMAppeals;       // Receive appeals for WGM Headquarters

  Subscriptions ({this.uid, this.nlEmail, this.nlSolheim, this.nlCallSnail, this.nlCallEmail, this.nlMinutemenHN, this.nlMinutemenWorld, this.nlWGMAppeals});
}

class MyInterests {
  final String uid = Home.myUID;
  final bool interestSubscribe;
  final String interestCategory;

  MyInterests ({uid, this.interestSubscribe, this.interestCategory});

}

class Stats {
  final String uid = Home.statID;
  final int statValue;
  final String statCategory;

  Stats ({uid, this.statValue, this.statCategory});

}

class MySubscribes {
  final String uid = Home.myUID;
  final bool subscribeSubscribe;
  final String subscribeCategory;

  MySubscribes ({uid, this.subscribeSubscribe, this.subscribeCategory});

}