import 'package:flutter/cupertino.dart';

abstract class SessionState{}

class UnKnownSessionState extends SessionState{}

class Unauthenticated extends SessionState{
  Exception e;
  Unauthenticated({this.e});
}

class Authenticated extends SessionState{

  final dynamic token;

  Authenticated({@required this.token});
}

