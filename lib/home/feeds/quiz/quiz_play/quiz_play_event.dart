abstract class QuizPlayEvent {}

class McqAnswered extends QuizPlayEvent {
  int feedIndex;
  String option;
  String answer;

  McqAnswered({this.feedIndex, this.option,this.answer});
}
class ShowPreviousMCQ extends QuizPlayEvent {}

class ShowNextMCQ extends QuizPlayEvent {}
class Finish extends QuizPlayEvent {}
