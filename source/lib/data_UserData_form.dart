import 'package:TeamSolheim/dbUserData.dart';
import 'package:TeamSolheim/home.dart';
import 'package:TeamSolheim/loading.dart';
import 'package:TeamSolheim/user.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TeamSolheim/shared.dart';

class UserDataForm extends StatefulWidget {
  @override
  _UserDataFormState createState() => _UserDataFormState();
}

class _UserDataFormState extends State<UserDataForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> arrayMaritalStatus = ['Single', 'Married', 'Widowed', 'Divorced', 'Other'];
  final List<String> arrayGender = ['Male', 'Female'];
  final List<String> arrayMonth = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  final List<int> arrayDate = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];

  // Temporary variable to hold updated information that needs to be uploaded to database.
  String _maritalStatus;         // array for single, married, widowed
  String _firstName1;            // husband's name or single male
  String _firstName2;            // wife's name or single female
  String _lastName;              // Last name
  String _birthMonth1;           // husband's birth month
  int    _birthDate1;            // husband's birth date
  String _birthMonth2;           // wife's birth month
  int    _birthDate2;            // wife's birth date
  String _kids;                  // list of kids and ages?
  int    _church;                // link to church
  String _gender;                // Male or Female


  void _userDataPanel() {
    print('***** Starting _userDataPanel');
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: UserDataForm(),
        );
      },
      isScrollControlled: true,
    );
  }

  void _updateGoogleData() async {
    await DBServiceUserData(uid: Home.myUID).updateGoogleData(
      Home.myUID,
      Home.displayName,
      Home.phoneNumber,
      Home.photoUrl,
      Home.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    print('***** Starting build widget');
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DBServiceUserData(uid: user.uid).userData,
        builder: (context, snapshot) {
          print('***** StreamBuilder');
          if(Home.firstLogin == true) {
            _updateGoogleData();
            Home.firstLogin = false;
          }
          if(snapshot.hasData){
            print('***** 1st IF statement');
            UserData userData = snapshot.data;
            //if(userData.gender == null) {

            if(Home.myCounter == 0) {                                           // Page 1 - Gender
              print('***** 2nd IF statement');
              return Scaffold(
                appBar: AppBar(
                  title: Text('Personal Information'),
                  backgroundColor: Home.appbarBG,
                  elevation: 0.0,
                ),
                body: Form( // Set gender
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      Text(
                        'Pick one:',
                        style: TextStyle(color: Home.basicTxt),
                      ),
                      DropdownButtonFormField(
                        decoration: textInputDecoration,
                        value: _gender ?? userData.gender,
                        items: arrayGender.map((vGender) {
                          print('***** arrayGender Map');
                          print(vGender);
                          return DropdownMenuItem(
                            value: vGender,
                            child: Text('$vGender'),
                          );
                        }).toList(),
                        onChanged: (data) {
                          print('***** onChanged method');
                          setState(() {
                            _gender = data;
                          });
                        },
                      ),
                      SizedBox(height: 20.0,),
                      RaisedButton(
                        color: Home.buttonBG,
                        child: Text(
                          'Save and Continue',
                          style: TextStyle(color: Home.buttonTxt),
                        ),
                        onPressed: () async {
                          print(Home.myCounter);
                          if (_formKey.currentState.validate()) {
                            print('***** 3rd IF statement (on pressed)');
                            await DBServiceUserData(uid: user.uid).updateUserData(
                              userData.dbLevel,
                              _maritalStatus ?? userData.maritalStatus,
                              _firstName1 ?? userData.firstName1,
                              _firstName2 ?? userData.firstName2,
                              _lastName ?? userData.lastName,
                              _birthMonth1 ?? userData.birthMonth1,
                              _birthDate1 ?? userData.birthDate1,
                              _birthMonth2 ?? userData.birthMonth2,
                              _birthDate2 ?? userData.birthDate2,
                              _kids ?? userData.kids,
                              _church ?? userData.church,
                              _gender ?? userData.gender,
                            );
                            Home.myCounter++;
                            print('***** End of Gender section');
                            Navigator.pop(context);
                            _userDataPanel();
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
              //} else if (userData.maritalStatus == null) {
            } else if(Home.myCounter == 1) {                                    // Page 2 - Marital status
              print('starting Marital Status section');
              print(Home.myCounter);
              return Scaffold(
                appBar: AppBar(
                  title: Text('${Home.title}'),
                  backgroundColor: Home.appbarBG,
                  elevation: 0.0,
                ),
                body: Form(                                                      // Set marital status
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      Text(
                        'Select one:',
                        style: TextStyle(color: Home.basicTxt),
                      ),
                      DropdownButtonFormField(
                        decoration: textInputDecoration,
                        value: _maritalStatus ?? userData.maritalStatus,
                        items: arrayMaritalStatus.map((vMaritalStatus) {
                          return DropdownMenuItem(
                            value: vMaritalStatus,
                            child: Text('$vMaritalStatus'),
                          );
                        }).toList(),
                        onChanged: (data) {
                          setState(() {
                            _maritalStatus = data;
                          });
                        },
                      ),
                      SizedBox(height: 20.0,),
                      RaisedButton(
                        color: Home.buttonBG,
                        child: Text(
                          'Save and Continue',
                          style: TextStyle(color: Home.buttonTxt),
                        ),
                        onPressed: () async {
                          if(_formKey.currentState.validate()) {
                            await DBServiceUserData(uid: user.uid).updateUserData(
                              userData.dbLevel,
                              _maritalStatus ?? userData.maritalStatus,
                              _firstName1 ?? userData.firstName1,
                              _firstName2 ?? userData.firstName2,
                              _lastName ?? userData.lastName,
                              _birthMonth1 ?? userData.birthMonth1,
                              _birthDate1 ?? userData.birthDate1,
                              _birthMonth2 ?? userData.birthMonth2,
                              _birthDate2 ?? userData.birthDate2,
                              _kids ?? userData.kids,
                              _church ?? userData.church,
                              _gender ?? userData.gender,
                            );
                            Home.myCounter++;
                            Navigator.pop(context);
                            _userDataPanel();
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            //} else if (userData.gender == 'Female' && userData.maritalStatus != 'Married') {
            } else if(Home.myCounter == 2 && userData.gender == 'Female') { // Page 3a = counter = 0 Female primary
              print('starting Primary Female section');
              print(Home.myCounter);
              return Form(                                                      // Primary Female - Set Name and Birth date
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0,),
                    TextFormField(                                              // Primary Female first name
                      initialValue: userData.firstName2,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'your first name'),
                      validator: (val) =>
                      val.isEmpty
                          ? 'Please enter first name'
                          : null,
                      onChanged: (val) => setState(() => _firstName2 = val),
                    ),
                    SizedBox(height: 10.0,),
                    TextFormField(                                              // Primary Female last name
                      initialValue: userData.lastName,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'your last name'),
                      validator: (val) =>
                      val.isEmpty
                          ? 'Please enter last name'
                          : null,
                      onChanged: (val) => setState(() => _lastName = val),
                    ),
                    SizedBox(height: 10.0,),
                    DropdownButtonFormField(                                    // Primary Female set birth month
                      decoration: textInputDecoration.copyWith(
                          hintText: 'your birth month'),
                      value: _birthMonth2 ?? userData.birthMonth2,
                      items: arrayMonth.map((vBirthMonth2) {
                        return DropdownMenuItem(
                          value: vBirthMonth2,
                          child: Text('$vBirthMonth2'),
                        );
                      }).toList(),
                      onChanged: (data) {
                        setState(() {
                          _birthMonth2 = data;
                        });
                      },
                    ),
                    SizedBox(height: 10.0,),
                    DropdownButtonFormField(                                    // Primary Female set birth date
                      decoration: textInputDecoration.copyWith(
                          hintText: 'your birth date'),
                      value: _birthDate2 ?? userData.birthDate2,
                      items: arrayDate.map((vBirthDate2) {
                        return DropdownMenuItem(
                          value: vBirthDate2,
                          child: Text('$vBirthDate2'),
                        );
                      }).toList(),
                      onChanged: (data) {
                        setState(() {
                          _birthDate2 = data;
                        });
                      },
                    ),
                    SizedBox(height: 20.0,),
                    RaisedButton(
                      color: Home.buttonBG,
                      child: Text(
                        'Save and Continue',
                        style: TextStyle(color: Home.buttonTxt),
                      ),
                      onPressed: () async {
//                        print(_maritalStatus);
//                        print(userData.maritalStatus);

                        if(_formKey.currentState.validate()) {
                          await DBServiceUserData(uid: user.uid).updateUserData(
                            userData.dbLevel,
                            _maritalStatus ?? userData.maritalStatus,
                            _firstName1 ?? userData.firstName1,
                            _firstName2 ?? userData.firstName2,
                            _lastName ?? userData.lastName,
                            _birthMonth1 ?? userData.birthMonth1,
                            _birthDate1 ?? userData.birthDate1,
                            _birthMonth2 ?? userData.birthMonth2,
                            _birthDate2 ?? userData.birthDate2,
                            _kids ?? userData.kids,
                            _church ?? userData.church,
                            _gender ?? userData.gender,
                          );
                          Home.myCounter++;
                          Navigator.pop(context);
                          _userDataPanel();

                        }
                      },
                    )
                  ],
                ),
              );
            //} else if (userData.gender == 'Male'   && userData.maritalStatus != 'Married') {
            } else if(Home.myCounter == 2 && userData.gender == 'Male') { // Page 3b = counter = 2 Male primary
              print('starting Primary Male section');
              print(Home.myCounter);
              return Scaffold(
                appBar: AppBar(
                  title: Text('Personal Information'),
                  backgroundColor: Home.appbarBG,
                  elevation: 0.0,
                ),
                body: Form(                                                      // Primary male - set Name and Birthdate
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      TextFormField(                                              // Primary male first name
                        initialValue: userData.firstName1,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'your first name'),
                        validator: (val) =>
                        val.isEmpty
                            ? 'Please enter first name'
                            : null,
                        onChanged: (val) => setState(() => _firstName1 = val),
                      ),
                      SizedBox(height: 10.0,),
                      TextFormField(                                              // Primary male last name
                        initialValue: userData.lastName,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'your last name'),
                        validator: (val) =>
                        val.isEmpty
                            ? 'Please enter last name'
                            : null,
                        onChanged: (val) => setState(() => _lastName = val),
                      ),
                      SizedBox(height: 10.0,),
                      DropdownButtonFormField(                                    // Primary male set birth month
                        decoration: textInputDecoration.copyWith(
                            hintText: 'your birth month'),
                        value: _birthMonth1 ?? userData.birthMonth1,
                        items: arrayMonth.map((vBirthMonth1) {
                          return DropdownMenuItem(
                            value: vBirthMonth1,
                            child: Text('$vBirthMonth1'),
                          );
                        }).toList(),
                        onChanged: (data) {
                          setState(() {
                            _birthMonth1 = data;
                          });
                        },
                      ),
                      SizedBox(height: 10.0,),
                      DropdownButtonFormField(                                    // Primary male set birth date
                        decoration: textInputDecoration.copyWith(
                            hintText: 'your last name'),
                        value: _birthDate1 ?? userData.birthDate1,
                        items: arrayDate.map((vBirthDate1) {
                          return DropdownMenuItem(
                            value: vBirthDate1,
                            child: Text('$vBirthDate1'),
                          );
                        }).toList(),
                        onChanged: (data) {
                          setState(() {
                            _birthDate1 = data;
                          });
                        },
                      ),
                      SizedBox(height: 20.0,),
                      RaisedButton(
                        color: Home.buttonBG,
                        child: Text(
                          'Save and Continue',
                          style: TextStyle(color: Home.buttonTxt),
                        ),
                        onPressed: () async {
                          print(_maritalStatus);
                          print(userData.maritalStatus);

                          if(_formKey.currentState.validate()) {
                            await DBServiceUserData(uid: user.uid).updateUserData(
                              userData.dbLevel,
                              _maritalStatus ?? userData.maritalStatus,
                              _firstName1 ?? userData.firstName1,
                              _firstName2 ?? userData.firstName2,
                              _lastName ?? userData.lastName,
                              _birthMonth1 ?? userData.birthMonth1,
                              _birthDate1 ?? userData.birthDate1,
                              _birthMonth2 ?? userData.birthMonth2,
                              _birthDate2 ?? userData.birthDate2,
                              _kids ?? userData.kids,
                              _church ?? userData.church,
                              _gender ?? userData.gender,
                            );
                            Home.myCounter++;
                            Navigator.pop(context);
                            _userDataPanel();
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            } else if(Home.myCounter == 3 && userData.gender == 'Male' && userData.maritalStatus == 'Married') { // Page 4a = counter = 3 Male primary (wife's data)
              print('starting Wife section');
              print(Home.myCounter);
              return Scaffold(
                appBar: AppBar(
                  title: Text('Personal Information'),
                  backgroundColor: Home.appbarBG,
                  elevation: 0.0,
                ),
                body: Form(                                                      // wife - set Name and Birthdate
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      TextFormField(                                              // wife first name
                        initialValue: userData.firstName2,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'wife\'s first name'),
                        validator: (val) =>
                        val.isEmpty
                            ? 'Please enter first name'
                            : null,
                        onChanged: (val) => setState(() => _firstName2 = val),
                      ),
                      SizedBox(height: 10.0,),
                      TextFormField(                                              // wife last name
                        initialValue: userData.lastName,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'wife\'s last name'),
                        validator: (val) =>
                        val.isEmpty
                            ? 'Please enter last name'
                            : null,
                        onChanged: (val) => setState(() => _lastName = val),
                      ),
                      SizedBox(height: 10.0,),
                      DropdownButtonFormField(                                    // wife set birth month
                        decoration: textInputDecoration.copyWith(
                            hintText: 'wife\'s birth month'),
                        value: _birthMonth2 ?? userData.birthMonth2,
                        items: arrayMonth.map((vBirthMonth2) {
                          return DropdownMenuItem(
                            value: vBirthMonth2,
                            child: Text('$vBirthMonth2'),
                          );
                        }).toList(),
                        onChanged: (data) {
                          setState(() {
                            _birthMonth2 = data;
                          });
                        },
                      ),
                      SizedBox(height: 10.0,),
                      DropdownButtonFormField(                                    // wife set birth date
                        decoration: textInputDecoration.copyWith(
                            hintText: 'wife\'s birth date'),
                        value: _birthDate2 ?? userData.birthDate2,
                        items: arrayDate.map((vBirthDate2) {
                          return DropdownMenuItem(
                            value: vBirthDate2,
                            child: Text('$vBirthDate2'),
                          );
                        }).toList(),
                        onChanged: (data) {
                          setState(() {
                            _birthDate2 = data;
                          });
                        },
                      ),
                      SizedBox(height: 20.0,),
                      RaisedButton(
                        color: Home.buttonBG,
                        child: Text(
                          'Save and Continue',
                          style: TextStyle(color: Home.buttonTxt),
                        ),
                        onPressed: () async {
                          if(_formKey.currentState.validate()) {
                            await DBServiceUserData(uid: user.uid).updateUserData(
                              userData.dbLevel,
                              _maritalStatus ?? userData.maritalStatus,
                              _firstName1 ?? userData.firstName1,
                              _firstName2 ?? userData.firstName2,
                              _lastName ?? userData.lastName,
                              _birthMonth1 ?? userData.birthMonth1,
                              _birthDate1 ?? userData.birthDate1,
                              _birthMonth2 ?? userData.birthMonth2,
                              _birthDate2 ?? userData.birthDate2,
                              _kids ?? userData.kids,
                              _church ?? userData.church,
                              _gender ?? userData.gender,
                            );
                            Home.myCounter++;
                            Navigator.pop(context);
                            _userDataPanel();
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            } else if(Home.myCounter == 3 && userData.gender == 'Female' && userData.maritalStatus == 'Married') { // Page 4a = counter = 3 Female primary (husband's data)
              print('starting Husband section');
              print(Home.myCounter);
              return Scaffold(
                appBar: AppBar(
                  title: Text('Personal Information'),
                  backgroundColor: Home.appbarBG,
                  elevation: 0.0,
                ),
                body: Form(                                                      // husband - set Name and Birthdate
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      TextFormField(                                              // husband first name
                        initialValue: userData.firstName1,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'husband\'s first name'),
                        validator: (val) =>
                        val.isEmpty
                            ? 'Please enter first name'
                            : null,
                        onChanged: (val) => setState(() => _firstName1 = val),
                      ),
                      SizedBox(height: 10.0,),
                      TextFormField(                                              // husband last name
                        initialValue: userData.lastName,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'husband\'s last name'),
                        validator: (val) =>
                        val.isEmpty
                            ? 'Please enter last name'
                            : null,
                        onChanged: (val) => setState(() => _lastName = val),
                      ),
                      SizedBox(height: 10.0,),
                      DropdownButtonFormField(                                    // husband set birth month
                        decoration: textInputDecoration.copyWith(
                            hintText: 'husband\'s birth month'),
                        value: _birthMonth1 ?? userData.birthMonth1,
                        items: arrayMonth.map((vBirthMonth1) {
                          return DropdownMenuItem(
                            value: vBirthMonth1,
                            child: Text('$vBirthMonth1'),
                          );
                        }).toList(),
                        onChanged: (data) {
                          setState(() {
                            _birthMonth1 = data;
                          });
                        },
                      ),
                      SizedBox(height: 10.0,),
                      DropdownButtonFormField(                                    // husband set birth date
                        decoration: textInputDecoration.copyWith(
                            hintText: 'husband\'s birth date'),
                        value: _birthDate1 ?? userData.birthDate1,
                        items: arrayDate.map((vBirthDate1) {
                          return DropdownMenuItem(
                            value: vBirthDate1,
                            child: Text('$vBirthDate1'),
                          );
                        }).toList(),
                        onChanged: (data) {
                          setState(() {
                            _birthDate1 = data;
                          });
                        },
                      ),
                      SizedBox(height: 20.0,),
                      RaisedButton(
                        color: Home.buttonBG,
                        child: Text(
                          'Save and Continue',
                          style: TextStyle(color: Home.buttonTxt),
                        ),
                        onPressed: () async {
                          print(_maritalStatus);
                          print(userData.maritalStatus);

                          if(_formKey.currentState.validate()) {
                            await DBServiceUserData(uid: user.uid).updateUserData(
                              userData.dbLevel,
                              _maritalStatus ?? userData.maritalStatus,
                              _firstName1 ?? userData.firstName1,
                              _firstName2 ?? userData.firstName2,
                              _lastName ?? userData.lastName,
                              _birthMonth1 ?? userData.birthMonth1,
                              _birthDate1 ?? userData.birthDate1,
                              _birthMonth2 ?? userData.birthMonth2,
                              _birthDate2 ?? userData.birthDate2,
                              _kids ?? userData.kids,
                              _church ?? userData.church,
                              _gender ?? userData.gender,
                            );
                            Home.myCounter++;
                            Navigator.pop(context);
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            } else {
              print('nothing more to do');
              print(Home.myCounter);
              return Scaffold(
                appBar: AppBar(
                  title: Text('${Home.title}'),
                  backgroundColor: Home.appbarBG,
                  elevation: 0.0,
                ),
                body: Form(                                                      // All done.
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0,),
                      RaisedButton(
                        color: Home.buttonBG,
                        child: Text(
                          'All done!',
                          style: TextStyle(color: Home.buttonTxt),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              );
            }
          } else {
            print('***** 1st ELSE statement');
            return
              Loading();
          }
        });
  }
}