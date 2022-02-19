import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/home/home/home_events.dart';
import 'package:queschat/home/home/home_state.dart';



class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeState(tabIndex: 0));

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    // for changing tab
    if (event is ChangeTab) {
      yield state.copyWith(tabIndex: event.index);
    }

  }
}