import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/form_submitting_status.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/report_a_content/report_bloc.dart';
import 'package:queschat/home/report_a_content/report_event.dart';
import 'package:queschat/home/report_a_content/report_state.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_button.dart';

void showReportAlert(
    {@required BuildContext buildContext,
    @required String reportedModel,
    @required reportedModelId}) {
  showModalBottomSheet(
      context: buildContext,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return BlocProvider(
          create: (context) => ReportBloc(),
          child: BlocListener<ReportBloc, ReportState>(
            listener: (context, state) {
              final formSubmissionStatus = state.formSubmissionStatus;
              if (formSubmissionStatus is SubmissionFailed) {
                showSnackBar(context, formSubmissionStatus.exception);
              }if(formSubmissionStatus is SubmissionSuccess){
                Navigator.of(context).pop();
              }
            },            child: BlocBuilder<ReportBloc, ReportState>(
                builder: (buildContext, state) {
              return SizedBox(
                height: MediaQuery.of(buildContext).size.height - 30,
                child: Scaffold(
                  appBar: appBarWithBackButton(
                      titleString: 'Report', context: context),
                  body: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Why are you reporting this',
                            style: TextStyles.mediumBoldTextSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.reasons.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  state.reasons[index],
                                  style: TextStyles.smallRegularTextSecondary,
                                ),
                                trailing: Radio(
                                  value: state.reasons[index],
                                  groupValue: state.reason,
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => AppColors.PrimaryColorLight),
                                  onChanged: (value) {
                                    context
                                        .read<ReportBloc>()
                                        .add(ReasonSelected(reason: value));
                                  },
                                  activeColor: Colors.green,
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 30),
                        child: state.formSubmissionStatus is FormSubmitting
                        ? CustomProgressIndicator():CustomButton(
                          action: () {
                            buildContext
                                .read<ReportBloc>()
                                .add(ReportSubmitted(reportedModelId: reportedModelId,reportedModel: reportedModel));
                          },
                          text: 'Submit',
                        ),
                      ),

                    ],
                  ),
                ),
              );
            }),
          ),
        );
      });
}
