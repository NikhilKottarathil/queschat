import 'package:flutter/cupertino.dart';

abstract class ReportEvent {}

class ReasonSelected extends ReportEvent {
  String reason;
  ReasonSelected({this.reason});
}

class ReportSubmitted extends ReportEvent {
  String reportedModel, reportedModelId;
  ReportSubmitted({this.reportedModel,this.reportedModelId});
}



