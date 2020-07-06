import 'package:TeamSolheim/authenticate.dart';
import 'package:TeamSolheim/home.dart';
import 'package:TeamSolheim/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);
    //Call Home (signed in) or Authenticate (not signed in)
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
