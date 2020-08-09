import 'package:TeamSolheim/dbSubscriptions.dart';
import 'package:TeamSolheim/home.dart';
import 'package:TeamSolheim/loading.dart';
import 'package:TeamSolheim/user.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionsForm extends StatefulWidget {
  @override
  _SubscriptionsFormState createState() => _SubscriptionsFormState();
}

class _SubscriptionsFormState extends State<SubscriptionsForm> {
  final _formKey = GlobalKey<FormState>();

  // Temporary variable to hold updated information that needs to be uploaded to database.
  String _nlEmail;
  bool   _nlSolheim;
  bool   _nlCallSnail;
  bool   _nlCallEmail;
  bool   _nlMinutemenHN;
  bool   _nlMinutemenWorld;
  bool   _nlWGMAppeals;

//  void _subscriptionsPanel() {
//    showModalBottomSheet(
//      context: context,
//      builder: (context) {
//        return Container(
//          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
//          child: SubscriptionsForm(),
//        );
//      },
//      isScrollControlled: true,
//    );
//  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<Subscriptions>(
      stream: DBServiceSubscriptions(uid: user.uid).subscriptions,
      builder: (context, snapshot) {
      if(snapshot.hasData){
        Subscriptions subscriptions = snapshot.data;
        //if(subscriptions.gender == null) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Subscriptions'),
            backgroundColor: Home.appbarBG,
            elevation: 0.0,
          ),
          body: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 5),                                      // Team Solheim Monthly Newsletter
                  Container(
                    width: 500,
                    color: Home.buttonBG,
                    child: CheckboxListTile(
                      value: subscriptions.nlSolheim,
                      checkColor: Colors.black,
                      activeColor: Colors.white,
                      title: Text(
                        'Team Solheim\nMonthly Newsletter',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),

                      onChanged: (_nlSolheim) async {
                        await DBServiceSubscriptions(uid: user.uid).updateSubscriptions(
                          _nlEmail ?? subscriptions.nlEmail,
                          _nlSolheim ?? subscriptions.nlSolheim,
                          _nlCallSnail ?? subscriptions.nlCallSnail,
                          _nlCallEmail ?? subscriptions.nlCallEmail,
                          _nlMinutemenHN ?? subscriptions.nlMinutemenHN,
                          _nlMinutemenWorld ?? subscriptions.nlMinutemenWorld,
                          _nlWGMAppeals ?? subscriptions.nlWGMAppeals,
                        );
                      }
                    ),
                  ),
                  Container(
                    width: 500,
                    color: Home.buttonBG,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        'Team Solheim highly recommends subscribing to our monthly newsletter. It is the best way to stay informed on the many events and projects we are working on.',
                        maxLines: 6,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),                                      // Team Solheim Campaigns
                  Container(
                    width: 500,
                    color: Home.buttonBG,
                    child: CheckboxListTile(
                        value: subscriptions.nlSolheim,
                        checkColor: Colors.black,
                        activeColor: Colors.white,
                        title: AutoSizeText(
                          'Team Solheim Campaigns',
                          maxLines: 1,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),

                        onChanged: (_nlMinutemenHN) async {
                          await DBServiceSubscriptions(uid: user.uid).updateSubscriptions(
                            _nlEmail ?? subscriptions.nlEmail,
                            _nlSolheim ?? subscriptions.nlSolheim,
                            _nlCallSnail ?? subscriptions.nlCallSnail,
                            _nlCallEmail ?? subscriptions.nlCallEmail,
                            _nlMinutemenHN ?? subscriptions.nlMinutemenHN,
                            _nlMinutemenWorld ?? subscriptions.nlMinutemenWorld,
                            _nlWGMAppeals ?? subscriptions.nlWGMAppeals,
                          );
                        }
                    ),
                  ),
                  Container(
                    width: 500,
                    color: Home.buttonBG,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: AutoSizeText(
                        'Team Solheim recommends subscribing to our campaigns. Campaigns are online fundraisers to meet specific fundraising goals. It might be for a VBS camp, purchase of a new vehicle, opening a new youth center or an emergency crisis.',
                        maxLines: 6,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  RaisedButton(
                    color: Home.buttonBG,
                    child: Text(
                      'Save and Continue',
                      style: TextStyle(color: Home.buttonTxt),
                    ),
                    onPressed: () async {

                      Navigator.pop(context);
                      //Navigator.popAndPushNamed(context, InterestPage())

                    },
                  )
                ],
              )),
        );
      } else {
        return Loading();
      }
      });
  }
}