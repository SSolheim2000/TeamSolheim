import 'package:TeamSolheim/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('***** Running Loading section');
    return Container(
      color: Home.scaffoldBG,
      child: Center(
        child: SpinKitChasingDots(
          color: Home.buttonBG,
          size: 50.0,
        ),
      ),
    );
  }
}
