import 'package:queschat/home/feeds/quiz/quiz_mcq/quiz_mcq_state.dart';
import 'package:queschat/home/feeds/quiz/quiz_mcq/quiz_mcq_view.dart';

abstract class PostQuizEvent {}

class HeadingChanged extends PostQuizEvent {
  final String heading;

  HeadingChanged({this.heading});
}
class ContentChanged extends PostQuizEvent {
  final String content;

  ContentChanged({this.content});
}
class SelectMedia extends PostQuizEvent {
  final media, context;

  SelectMedia({this.media, this.context});
}



class CreateQuizSubmitted extends PostQuizEvent {}


class AddNewMCQ extends PostQuizEvent {
  QuizMcqState quizMcqState;
  AddNewMCQ(this.quizMcqState);
}
class ShowPreviousMCQ extends PostQuizEvent {
  QuizMcqState quizMcqState;
  ShowPreviousMCQ(this.quizMcqState);
}
class ShowNextMCQ extends PostQuizEvent {
  QuizMcqState quizMcqState;
  ShowNextMCQ(this.quizMcqState);
}


class PostQuizSubmitted extends PostQuizEvent {
  QuizMcqState quizMcqState;
  PostQuizSubmitted(this.quizMcqState);
}

class ClearAllFields extends PostQuizEvent {}
