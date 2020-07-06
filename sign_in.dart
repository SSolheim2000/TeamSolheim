import 'package:TeamSolheim/authsvc.dart';
import 'package:TeamSolheim/home.dart';
import 'package:flutter/material.dart';
import 'package:TeamSolheim/shared.dart';
import 'package:TeamSolheim/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //text field states
    String email = '';
    String password = '';
    String error = '';
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Home.scaffoldBG,
      appBar: AppBar(
        backgroundColor: Home.appbarBG,
        elevation: 0.0,
        title: Text('${Home.title}'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person, color: Home.buttonTxt),
            label: Text('Register', style: TextStyle( color: Home.buttonTxt)),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                validator: (val) => val.length < 6 ? 'Enter 6 or more characters' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Home.buttonBG,
                child: Text(
                  'Sign in',
                  style: TextStyle( color: Home.buttonTxt),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    print(email);
                    print(password);
                    setState(() => loading = true);
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() {
                        loading = false;
                        error = 'Could not sign in.';
                      });
                    }
                  }
                }
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Home.buttonBG,
                child: Text(
                  'Sign in with Google',
                  style: TextStyle( color: Home.buttonTxt),
                ),
                onPressed: () async {
                  print('Logging in with Google');
                  setState(() => loading = true);
                  dynamic result = await _auth.signInGoogle();
                  if (result == null) {
                    setState(() {
                      loading = false;
                      error = 'Could not sign in.';
                    });
                  }
                }
              ),
              Text(
                error,
                style: TextStyle(color: Home.errorTxt, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
