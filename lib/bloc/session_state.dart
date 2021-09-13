import 'package:flutter/cupertino.dart';

abstract class SessionState{}

class UnKnownSessionState extends SessionState{}

class Unauthenticated extends SessionState{}

class Authenticated extends SessionState{

  final dynamic token;

  Authenticated({@required this.token});
}

