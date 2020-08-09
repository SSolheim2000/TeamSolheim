import 'package:TeamSolheim/dbContactInfo.dart';
import 'package:TeamSolheim/home.dart';
import 'package:TeamSolheim/loading.dart';
import 'package:TeamSolheim/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TeamSolheim/shared.dart';

class ContactInfoForm extends StatefulWidget {
  @override
  _ContactInfoFormState createState() => _ContactInfoFormState();
}

class _ContactInfoFormState extends State<ContactInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> arrayPrimaryEmail = ['Primary', 'Secondary', 'Work'];
  final List<String> arrayPrimaryPhone = ['Primary', 'Secondary', 'Work'];

  // Temporary variable to hold updated information that needs to be uploaded to database.
  String _email0;
  String _email1;
  String _email2;
  String _primaryEmail;
  String _priAddress1;
  String _priAddress2;
  String _priCity;
  String _priState;
  String _priZip;
  String _phone0;
  String _phone1;
  String _phone2;
  String _primaryPhone;

  void _contactInfoPanel() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: ContactInfoForm(),
        );
      },
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<ContactInfo>(
        stream: DBServiceContactInfo(uid: user.uid).contactInfo,
        builder: (context, snapshot1) {
          if(snapshot1.hasData){
            ContactInfo contactInfo = snapshot1.data;
            print('myCounter is set to: {$Home.myCounter} - HAS DATA');
            if(Home.myCounter == 0) {                                           // Page 1 - SET EMAIL INFORMATION
              print('starting Gender section');
              print(Home.myCounter);
              return Scaffold(
                appBar: AppBar(
                  title: Text('Contact Information'),
                  backgroundColor: Home.appbarBG,
                  elevation: 0.0,
                ),
                body: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 5.0,),
                      Text(
                        'Primary email address',
                        style: TextStyle(color: Home.basicTxt),
                      ),
                      TextFormField(                                              // Email 0 (primary)
                        initialValue: contactInfo.email0,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'your primary email'),
                        validator: (val) =>
                        val.isEmpty
                            ? 'Please enter a valid email address'
                            : null,
                        onChanged: (val) => setState(() => _email0 = val),
                      ),
                      SizedBox(height: 5.0,),
                      Text(
                        'Secondary email address',
                        style: TextStyle(color: Home.basicTxt),
                      ),
                      TextFormField(                                              // Email 1 (spouse)
                        initialValue: contactInfo.email1,
                        decoration: textInputDecoration.copyWith(
                            hintText: "your spouse's or seconday email"),
                        onChanged: (val) => setState(() => _email1 = val),
                      ),
                      SizedBox(height: 5.0,),
                      Text(
                        'Work email address',
                        style: TextStyle(color: Home.basicTxt),
                      ),
                      TextFormField(                                              // Email 2 (work)
                        initialValue: contactInfo.email2,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'your work email'),
                        onChanged: (val) => setState(() => _email2 = val),
                      ),
                      SizedBox(height: 10.0,),
                      Text(
                        'Select your preferred email address',
                        style: TextStyle(color: Home.basicTxt),
                      ),
                      DropdownButtonFormField(                                    // Set primary email
                        decoration: textInputDecoration,
                        value: _primaryEmail ?? contactInfo.primaryEmail,
                        items: arrayPrimaryEmail.map((vPrimaryEmail) {
                          return DropdownMenuItem(
                            value: vPrimaryEmail,
                            child: Text('$vPrimaryEmail'),
                          );
                        }).toList(),
                        onChanged: (data) {
                          setState(() {
                            _primaryEmail = data;
                          });
                        },
                      ),
                      SizedBox(height: 10.0,),
                      SizedBox(height: 40.0, width: 500.0,
                        child: RaisedButton(
                          color: Home.buttonBG,
                          child: Text(
                            'Save and Continue',
                            style: TextStyle(color: Home.buttonTxt),
                          ),
                          onPressed: () async {
                            print(Home.myCounter);
                            if (_formKey.currentState.validate()) {
                              await DBServiceContactInfo(uid: user.uid).updateContactInfo(
                                _email0 ?? contactInfo.email0,
                                _email1 ?? contactInfo.email1,
                                _email2 ?? contactInfo.email2,
                                _primaryEmail ?? contactInfo.primaryEmail,
                                _priAddress1 ?? contactInfo.priAddress1,
                                _priAddress2 ?? contactInfo.priAddress2,
                                _priCity ?? contactInfo.priCity,
                                _priState ?? contactInfo.priState,
                                _priZip ?? contactInfo.priZip,
                                _phone0 ?? contactInfo.phone0,
                                _phone1 ?? contactInfo.phone1,
                                _phone2 ?? contactInfo.phone2,
                                _primaryPhone ?? contactInfo.primaryPhone,
                              );
                              Home.myCounter++;
                              print(Home.myCounter);
                              Navigator.pop(context);
                              _contactInfoPanel();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else if(Home.myCounter == 1) {                                    // PAGE 2 - SET PHONE INFORMATION
              return Scaffold(
                appBar: AppBar(
                  title: Text('Contact Information'),
                  backgroundColor: Home.appbarBG,
                  elevation: 0.0,
                ),
                body: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 5.0,),
                      Text(
                        'Primary phone number (Mobile)',
                        style: TextStyle(color: Home.basicTxt),
                      ),
                      TextFormField(                                              // Phone 0 (primary)
                        initialValue: contactInfo.phone0,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'your primary phone number'),
                        validator: (val) =>
                        val.isEmpty
                            ? 'Please enter a valid phone number'
                            : null,
                        onChanged: (val) => setState(() => _phone0 = val),
                      ),
                      SizedBox(height: 5.0,),
                      Text(
                        'Secondary phone number (Home)',
                        style: TextStyle(color: Home.basicTxt),
                      ),
                      TextFormField(                                              // Phone 1 (spouse)
                        initialValue: contactInfo.phone1,
                        decoration: textInputDecoration.copyWith(
                            hintText: "your spouse's or home phone number"),
                        onChanged: (val) => setState(() => _phone1 = val),
                      ),
                      SizedBox(height: 5.0,),
                      Text(
                        'Work phone number',
                        style: TextStyle(color: Home.basicTxt),
                      ),
                      TextFormField(                                              // Phone 2 (work)
                        initialValue: contactInfo.phone2,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'your work phone number'),
                        onChanged: (val) => setState(() => _phone2 = val),
                      ),
                      SizedBox(height: 10.0,),
                      Text(
                        'Select your preferred phone number',
                        style: TextStyle(color: Home.basicTxt),
                      ),
                      DropdownButtonFormField(                                    // Set primary phone number
                        decoration: textInputDecoration,
                        value: _primaryPhone ?? contactInfo.primaryPhone,
                        items: arrayPrimaryPhone.map((vPrimaryPhone) {
                          return DropdownMenuItem(
                            value: vPrimaryPhone,
                            child: Text('$vPrimaryPhone'),
                          );
                        }).toList(),
                        onChanged: (data) {
                          setState(() {
                            _primaryPhone = data;
                          });
                        },
                      ),
                      SizedBox(height: 10.0,),
                      SizedBox(height: 40.0, width: 500.0,
                        child: RaisedButton(
                          color: Home.buttonBG,
                          child: Text(
                            'Save and Continue',
                            style: TextStyle(color: Home.buttonTxt),
                          ),
                          onPressed: () async {
                            print(Home.myCounter);
                            if (_formKey.currentState.validate()) {
                              await DBServiceContactInfo(uid: user.uid).updateContactInfo(
                                _email0 ?? contactInfo.email0,
                                _email1 ?? contactInfo.email1,
                                _email2 ?? contactInfo.email2,
                                _primaryEmail ?? contactInfo.primaryEmail,
                                _priAddress1 ?? contactInfo.priAddress1,
                                _priAddress2 ?? contactInfo.priAddress2,
                                _priCity ?? contactInfo.priCity,
                                _priState ?? contactInfo.priState,
                                _priZip ?? contactInfo.priZip,
                                _phone0 ?? contactInfo.phone0,
                                _phone1 ?? contactInfo.phone1,
                                _phone2 ?? contactInfo.phone2,
                                _primaryPhone ?? contactInfo.primaryPhone,
                              );
                              Home.myCounter++;
                              print(Home.myCounter);
                              Navigator.pop(context);
                              _contactInfoPanel();
                            }
                          },
                        ),
                      ),
                      
                    ],
                  ),
                ),
              );
            } else if(Home.myCounter == 2) {                                    // PAGE 3 - SET MAILING ADDRESS
              return Scaffold(
                appBar: AppBar(
                  title: Text('Contact Information'),
                  backgroundColor: Home.appbarBG,
                  elevation: 0.0,
                ),
                body: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 5.0,),
                      Text(                                                       // Address line 1)
                        'Primary mailing address',
                        style: TextStyle(color: Home.basicTxt),
                      ),
                      TextFormField(

                        initialValue: contactInfo.priAddress1,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'your street address'),
                        validator: (val) =>
                        val.isEmpty
                            ? 'Please enter a valid address'
                            : null,
                        onChanged: (val) => setState(() => _priAddress1 = val),
                      ),
                      SizedBox(height: 5.0,),
                      Text(                                                       // Address line 2
                        'Street address continued',
                        style: TextStyle(color: Home.basicTxt),
                      ),
                      TextFormField(
                        initialValue: contactInfo.priAddress2,
                        decoration: textInputDecoration.copyWith(
                            hintText: "Apartment or PO Box"),
                        onChanged: (val) => setState(() => _priAddress2 = val),
                      ),
                      SizedBox(height: 5.0,),
                      Text(                                                       // City
                        'City',
                        style: TextStyle(color: Home.basicTxt),
                      ),
                      TextFormField(
                        initialValue: contactInfo.priCity,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'city'),
                        onChanged: (val) => setState(() => _priCity = val),
                      ),
                      SizedBox(height: 5.0,),
                      Row(
                        children: <Widget>[
                          Expanded( flex: 5,
                            child: SizedBox(width: 150.0,
                              child: Text(                                                       // State
                                'State',
                                style: TextStyle(color: Home.basicTxt),
                              ),
                            ),
                          ),
                          Expanded( flex: 1,
                              child: SizedBox(width: 5.0)
                          ),
                          Expanded( flex: 5,
                            child: SizedBox(width: 150.0,
                              child: Text(                                                       // Zip
                                'ZIP code',
                                style: TextStyle(color: Home.basicTxt),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(flex: 5,
                            child: SizedBox(
                              width: 150.0,
                              child: TextFormField(
                                initialValue: contactInfo.priState,
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'state'),
                                onChanged: (val) => setState(() => _priState = val),
                              ),
                            ),
                          ),
                          Expanded( flex: 1,
                              child: SizedBox(width: 5.0)
                          ),
                          Expanded( flex: 5,
                            child: SizedBox(width: 150,
                              child: TextFormField(
                                initialValue: contactInfo.priZip,
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'zip code'),
                                onChanged: (val) => setState(() => _priZip = val),
                              ),
                            ),
                          )
                        ],
                      ),


                      SizedBox(height: 10.0,),
                      SizedBox(height: 40.0, width: 500.0,
                        child: RaisedButton(
                          color: Home.buttonBG,
                          child: Text(
                            'Save and Continue',
                            style: TextStyle(color: Home.buttonTxt),
                          ),
                          onPressed: () async {
                            print(Home.myCounter);
                            if (_formKey.currentState.validate()) {
                              await DBServiceContactInfo(uid: user.uid).updateContactInfo(
                                _email0 ?? contactInfo.email0,
                                _email1 ?? contactInfo.email1,
                                _email2 ?? contactInfo.email2,
                                _primaryEmail ?? contactInfo.primaryEmail,
                                _priAddress1 ?? contactInfo.priAddress1,
                                _priAddress2 ?? contactInfo.priAddress2,
                                _priCity ?? contactInfo.priCity,
                                _priState ?? contactInfo.priState,
                                _priZip ?? contactInfo.priZip,
                                _phone0 ?? contactInfo.phone0,
                                _phone1 ?? contactInfo.phone1,
                                _phone2 ?? contactInfo.phone2,
                                _primaryPhone ?? contactInfo.primaryPhone,
                              );
                              Home.myCounter++;
                              print(Home.myCounter);
                              Navigator.pop(context);
                              _contactInfoPanel();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {                                                            // PAGE 4 = ALL DONE
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
            print('myCounter is set to: ${Home.myCounter} - Loading screen');
            return Loading();
          }
        });
  }
}