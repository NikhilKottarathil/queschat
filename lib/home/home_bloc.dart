import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/home/home_events.dart';
import 'package:queschat/home/home_state.dart';



class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeState());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    // for changing tab
    if (event is ChangeTab) {
      yield state.copyWith(tabIndex: event.index);
    }
    // else if (event is LoginPasswordChanged) {
  //     yield state.copyWith(password: event.password);
  //
  //     // Form submitted
  //   } else if (event is LoginSubmitted) {
  //     yield state.copyWith(formStatus: FormSubmitting());
  //
  //     try {
  //       final token= await authRepo.login(phoneNumber:state.phoneNumber,password: state.password );
  //       yield state.copyWith(formStatus: SubmissionSuccess());
  //       authCubit.showSession(new AuthCredentials(token: token));
  //     } catch (e) {
  //       yield state.copyWith(formStatus: SubmissionFailed(e));
  //       yield state.copyWith(formStatus: InitialFormStatus());
  //     }
  //   }
  }
}