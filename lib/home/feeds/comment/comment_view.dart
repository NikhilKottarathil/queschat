import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/feeds/comment/comment_adapter.dart';
import 'package:queschat/home/feeds/comment/comment_bloc.dart';
import 'package:queschat/home/feeds/comment/comment_event.dart';
import 'package:queschat/home/feeds/comment/comment_model.dart';
import 'package:queschat/home/feeds/comment/comment_state.dart';
import 'package:queschat/home/feeds/feeds_status.dart';
import 'package:queschat/home/report_a_content/report_view.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_button.dart';

class CommentView extends StatefulWidget {
  String feedId;
  int index;

  CommentView({this.index, this.feedId});

  @override
  _CommentViewState createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  ScrollController scrollController = new ScrollController();
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // context.read<CommentBloc>().add(FetchMoreData());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: appBarWithBackButton(
          context: context,
          titleString: 'Comments',
        ),
        body: BlocListener<CommentBloc, CommentState>(
          listener: (context, state) async {
            if (state.pageScrollStatus is ScrollToTop) {
              SchedulerBinding.instance?.addPostFrameCallback((_) {
                scrollController.animateTo(
                    scrollController.position.minScrollExtent,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.fastOutSlowIn);
              });
            }

            if (state.indexOfSelectedCommentForDelete != null &&
                state.indexOfSelectedCommentForDelete != -1) {
              if(state.indexOfSelectedCReplayForDelete==null  || state.indexOfSelectedCReplayForDelete==-1) {
                //comment
                if(state.commentModelList[state.indexOfSelectedCommentForDelete].userId==AppData().userId) {
                  showDeleteAlert(context);
                }else {
                  showReportAlert(buildContext: context,
                      reportedModel: 'Connection',
                      reportedModelId: state.commentModelList[state.indexOfSelectedCommentForDelete].id);
                }
              }else{
                // replay
                print(state.commentModelList[state.indexOfSelectedCommentForDelete].replays[state.indexOfSelectedCReplayForDelete].userId);
                print(AppData().userId);
                if(state.commentModelList[state.indexOfSelectedCommentForDelete].replays[state.indexOfSelectedCReplayForDelete].userId==AppData().userId) {
                  showDeleteAlert(context);
                }else {
                  showReportAlert(buildContext: context,
                      reportedModel: 'Connection',
                      reportedModelId: state.commentModelList[state.indexOfSelectedCommentForDelete].replays[state.indexOfSelectedCReplayForDelete].id);
                  context.read<CommentBloc>().add(
                      ShowDeleteAndReport(replayIndex: -1, commentIndex: -1));
                }

              }
            }
          },
          child:
              BlocBuilder<CommentBloc, CommentState>(builder: (context, state) {
            print(state.commentModelList.length);
            if (state.comment == '') {
              controller.text = state.comment;
            }
            return Column(
              children: [
                // FeedAdapter(widget.index),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(20),
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: state.commentModelList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CommentAdapter(index);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                  ),
                ),
                state.isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CustomProgressIndicator(),
                      )
                    : Container(),
                _replayFloating(),
                BlocBuilder<CommentBloc, CommentState>(
                    builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                        color: AppColors.White,

                        boxShadow: appShadow
                    ),
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      controller: controller,
                      validator: (value) {
                        return state.commentValidationText;
                      },
                      onChanged: (value) {
                        context.read<CommentBloc>().add(
                              CommentChanged(comment: value),
                            );
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Write your comment…",
                          suffixIcon: IconButton(
                            onPressed: () {
                              context.read<CommentBloc>().add(
                                    AddNewComment(),
                                  );
                            },
                            icon: Icon(
                              Icons.send,
                              color:state.comment.isNotEmpty? AppColors.PrimaryColor:AppColors.IconColor,
                            ),
                          )),
                    ),
                  );
                })
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _replayFloating() {
    return BlocBuilder<CommentBloc, CommentState>(builder: (context, state) {
      CommentModel commentModel;
      if (state.indexOfSelectedComment != null &&
          state.indexOfSelectedComment != -1) {
        commentModel = state.commentModelList[state.indexOfSelectedComment];
      }

      print(state.indexOfSelectedComment);
      return state.indexOfSelectedComment != null &&
              state.indexOfSelectedComment != -1
          ? Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  color: AppColors.SecondaryColor,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade200, blurRadius: 2)
                  ],
                 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if(commentModel.profilePicUrl!=null)
                      CircleAvatar(
                        radius: 12,
                       backgroundImage:  NetworkImage(
                           commentModel.profilePicUrl.toString()),
                      ),
                      if(commentModel.profilePicUrl==null)
                      CircleAvatar(
                        radius: 12,
                       child: Image.asset('images/user_profile.png'),
                      ),

                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        commentModel.userName,
                        style: TextStyles.mediumMediumWhite
                      ),
                    ],
                  ),
                  IconButton(
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.all(10),
                      icon: Icon(
                        Icons.clear,
                        color: AppColors.White,
                      ),
                      onPressed: () {
                        context
                            .read<CommentBloc>()
                            .add(CommentSelectedForReplay(index: null));
                      }),
                ],
              ))
          : Container();
    });
  }

  void showDeleteAlert(BuildContext buildContext) {
    showModalBottomSheet(
        context: buildContext,
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: Colors.white,
        builder: (context) {
          return BlocProvider.value(
            value: buildContext.read<CommentBloc>(),
            child: BlocBuilder<CommentBloc, CommentState>(
                builder: (buildContext, state) {
              return WillPopScope(
                onWillPop: () async {
                  buildContext.read<CommentBloc>().add(
                      ShowDeleteAndReport(replayIndex: -1, commentIndex: -1));

                  return true;
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      action: () {
                        buildContext.read<CommentBloc>().add(ConfirmDelete());
                        Navigator.pop(context);
                      },
                      text: 'Delete',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 20),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyles.smallRegularTextSecondary,
                          )),
                    )
                  ],
                ),
              );
            }),
          );
        });
  }


}
