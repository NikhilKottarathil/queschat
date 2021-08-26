import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queschat/authentication/LoginPage.dart';

import 'Testing/test1.dart';
import 'Trash.dart';

void main(){



  runApp(new MaterialApp(
    title: "Queschat",
    theme: ThemeData(
      fontFamily: 'NunitoSans_Regular',
      // scaffoldBackgroundColor: Colors.grey.shade50
    ),
    home:LoginPage(),
    // home:MyStatefulWidget(),

  ));


}


// void main() => runApp(
//   new MaterialApp(
//     builder: (context, child) => new SafeArea(child: new Material(color: Colors.white, child: child)),
//     home: new MyStatefulWidget(),
//   ),
// );