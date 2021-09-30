import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/function/api_calls.dart';
import 'package:queschat/home/report_a_content/report_event.dart';
import 'package:queschat/home/report_a_content/report_state.dart';


class ReportBloc extends Bloc<ReportEvent, ReportState> {


  ReportBloc() : super(ReportState());


  @override
  Stream<ReportState> mapEventToState(ReportEvent event) async* {
    if (event is ReasonSelected) {
      yield state.copyWith(reason: event.reason);
    } else if (event is ReportSubmitted) {
      yield state.copyWith(formSubmissionStatus: FormSubmitting());

      try {
        dynamic requestBody = {
          'reported_model': event.reportedModel,
          'reported_model_id': event.reportedModelId,
          'report': state.reason,
        };
        print(requestBody);
        var body= await postDataRequest(address: 'reported_item', myBody: requestBody);
        if(body['message']=="Successfully Created") {
          yield state.copyWith(formSubmissionStatus: SubmissionSuccess());
        }else{
          Exception e= Exception('Failed! Please retry');
          yield state.copyWith(formSubmissionStatus: SubmissionFailed(e));
          yield state.copyWith(formSubmissionStatus: InitialFormStatus());
        }
      } catch (e) {
        yield state.copyWith(formSubmissionStatus: SubmissionFailed(e));
        yield state.copyWith(formSubmissionStatus: InitialFormStatus());
      }
    }
  }
}
