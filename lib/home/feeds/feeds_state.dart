import 'package:queschat/home/feeds/feeds_status.dart';
import 'package:queschat/models/feed_model.dart';

class FeedsState {
  List<FeedModel> feedModelList=[];
  PageScrollStatus pageScrollStatus;
  int page;
  List<String> feedIds=[];
  bool isLoading;

  FeedsState({
    this.feedModelList,
    this.pageScrollStatus=const InitialStatus(),
    this.feedIds,
    this.page=1,
    this.isLoading=false
  });

  FeedsState copyWith({
    var feedModelList,
    var feedIds,
    bool isLoading,
    PageScrollStatus pageScrollStatus,
    int page,
  }) {
    return FeedsState(
      feedModelList: feedModelList ?? this.feedModelList,
      feedIds: feedIds ?? this.feedIds,
      pageScrollStatus: pageScrollStatus ?? this.pageScrollStatus,
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
    );
  }
}
