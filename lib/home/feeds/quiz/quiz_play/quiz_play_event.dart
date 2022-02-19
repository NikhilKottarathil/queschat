abstract class QuizPlayEvent {}

class McqAnswered extends QuizPlayEvent {
  int feedIndex;
  String option;
  String answer;

  McqAnswered({this.feedIndex, this.option,this.answer});
}
class ShowPreviousMCQ extends QuizPlayEvent {}
class TimerChanged extends QuizPlayEvent {
  int duration;

  TimerChanged({this.duration});
}

class ShowNextMCQ extends QuizPlayEvent {}
class Finished extends QuizPlayEvent {

}
