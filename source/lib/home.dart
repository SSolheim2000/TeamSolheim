import 'package:TeamSolheim/authsvc.dart';
import 'package:TeamSolheim/card_blog.dart';
import 'package:TeamSolheim/card_subscribe.dart';
import 'package:TeamSolheim/card_campaign.dart';
import 'package:TeamSolheim/card_interests.dart';
import 'package:TeamSolheim/card_newsletter.dart';
import 'package:TeamSolheim/data_ContactInfo_form.dart';
import 'package:TeamSolheim/data_UserData_form.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  static int myCounter = 0;
  static String title = 'Team Solheim';
  static Color buttonBG = Colors.lime[600];
  static Color scaffoldBG = Colors.white;
  static Color appbarBG = Colors.black;
  static Color buttonTxt = Colors.white;
  static dynamic fieldBG = Colors.white;
  static Color fieldBorder = Colors.lime[600];
  static Color errorTxt = Colors.red;
  static Color basicTxt = Colors.black;
  final AuthService _auth = AuthService();
  // Data from Google account
  static String myUID;
  static String displayName;
  static String phoneNumber;
  static String photoUrl;
  static String login;
  static bool firstLogin = true;
  // Interest Card variables
  static String interestID;
  static String interestUpdateID;
  static dynamic interests;
  static dynamic snapInterests;
  static Map mapInterests = Map<dynamic, dynamic>();
  // Subscribe Card variables
  static String subscribeID;
  static String subscribeUpdateID;
  static dynamic subscribes;
  static dynamic snapSubscribes;
  static Map mapSubscribes = Map<dynamic, dynamic>();
  // Stats Card variables
  static String statID;
  static dynamic stats;
  static dynamic snapStats;
  static String category;

  @override
  Widget build(BuildContext context) {
    void _userDataPanel() {
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

    void _interestsPanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: InterestPage(),
          );
        },
        isScrollControlled: true,
      );
    }

    void _subscribesPanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: SubscribePage(),
          );
        },
        isScrollControlled: true,
      );
    }

    void _newsletterPanel() {
      print('Launching NewsletterForm');
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: NewsletterPage(),
          );
        },
        isScrollControlled: true,
      );
    }

    void _blogsPanel() {
      print('Launching NewsletterForm');
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: BlogPage(),
          );
        },
        isScrollControlled: true,
      );
    }

    void _campaignsPanel() {
      print('Launching CampaignsForm');
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: CampaignPage(),
          );
        },
        isScrollControlled: true,
      );
    }


    return Scaffold(
      backgroundColor: Home.scaffoldBG,
      appBar: AppBar(
        title: Text('${Home.title}'),
        backgroundColor: Home.appbarBG,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person, color: Home.buttonTxt),
            label: Text('logout', style: TextStyle(color: Home.buttonTxt)),
            onPressed: () async {
              await _auth.signOutFirebase();
              await _auth.signOutGoogle();
              Home.firstLogin = true;
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 5.0,),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () async {
                          String url = 'https://teamsolheim.org/give';
                          if (await canLaunch(url)) {
                          await launch(url);
                          } else {
                          throw 'Could not launch $url';
                          }
                        },
                        child: Image(
                          image: AssetImage('assets/app_give.png'),
                          fit: BoxFit.contain,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () async {
                          String url = 'https://www.teamsolheim.org/get_involved';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Image(
                          image: AssetImage('assets/app_act.png'),
                          fit: BoxFit.contain,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () async {
                          String url = 'https://www.teamsolheim.org/swag';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Image(
                          image: AssetImage('assets/app_gear.png'),
                          fit: BoxFit.contain,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0,),
              SizedBox(height: 60.0, width: 500.0,
                child: RaisedButton(
                  color: Home.buttonBG,
                  onPressed: () {
                    myCounter = 0;
                    _campaignsPanel();
                  },
                  child: Text('Campaigns', style: TextStyle(color: Home.buttonTxt, fontSize: 24.0)),
                ),
              ),
              SizedBox(height: 5.0,),
              SizedBox(height: 60.0, width: 500.0,
                child: RaisedButton(
                  color: Home.buttonBG,
                  onPressed: () {
                    myCounter = 0;
                    _userDataPanel();
                  },
                  child: Text('Personal information', style: TextStyle(color: Home.buttonTxt, fontSize: 24.0)),
                ),
              ),
              SizedBox(height: 5.0,),
              SizedBox(height: 60.0, width: 500.0,
                child: RaisedButton(
                  color: Home.buttonBG,
                  onPressed: () {
                    myCounter = 0;
                    _contactInfoPanel();
                  },
                  child: Text('Contact information', style: TextStyle(color: Home.buttonTxt, fontSize: 24.0)),
                ),
              ),
              SizedBox(height: 5.0,),
              SizedBox(height: 60.0, width: 500.0,
                child: RaisedButton(
                  color: Home.buttonBG,
                  onPressed: () {
                    myCounter = 0;
                    _subscribesPanel();
                  },
                  child: Text('Manage Subscriptions', style: TextStyle(color: Home.buttonTxt, fontSize: 24.0)),
                ),
              ),
              SizedBox(height: 5.0,),
              SizedBox(height: 60.0, width: 500.0,
                child: RaisedButton(
                  color: Home.buttonBG,
                  onPressed: () {
                    myCounter = 0;
                    _interestsPanel();
                  },
                  child: Text('Manage Notifications', style: TextStyle(color: Home.buttonTxt, fontSize: 24.0)),
                ),
              ),
              SizedBox(height: 5.0,),
              SizedBox(height: 60.0, width: 500.0,
                child: RaisedButton(
                  color: Home.buttonBG,
                  onPressed: () {
                    print('Launching _newsletterPanel');
                    myCounter = 0;
                    _newsletterPanel();
                  },
                  child: Text('Newsletters', style: TextStyle(color: Home.buttonTxt, fontSize: 24.0)),
                ),
              ),
              SizedBox(height: 5.0,),
              SizedBox(height: 60.0, width: 500.0,
                child: RaisedButton(
                  color: Home.buttonBG,
                  onPressed: () {
                    print('Launching _blogsPanel');
                    myCounter = 0;
                    _blogsPanel();
                  },
                  child: Text('Blogs', style: TextStyle(color: Home.buttonTxt, fontSize: 24.0)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}