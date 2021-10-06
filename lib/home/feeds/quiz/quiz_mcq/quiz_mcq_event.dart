import 'package:flutter/cupertino.dart';

abstract class QuizMcqEvent {}

class QuestionChanged extends QuizMcqEvent {
  final String question;

  QuestionChanged({this.question});
}

class SelectQuestionImages extends QuizMcqEvent {
  BuildContext context;

  SelectQuestionImages({this.context});
}

class ChooseOptionType extends QuizMcqEvent {}

class OptionAChanged extends QuizMcqEvent {
  final String optionA;

  OptionAChanged({this.optionA});
}

class OptionBChanged extends QuizMcqEvent {
  final String optionB;

  OptionBChanged({this.optionB});
}

class OptionCChanged extends QuizMcqEvent {
  final String optionC;

  OptionCChanged({this.optionC});
}

class OptionDChanged extends QuizMcqEvent {
  final String optionD;

  OptionDChanged({this.optionD});
}

class SelectOptionAImage extends QuizMcqEvent {
  BuildContext context;

  SelectOptionAImage(this.context);
}

class SelectOptionBImage extends QuizMcqEvent {
  BuildContext context;

  SelectOptionBImage(this.context);
}

class SelectOptionCImage extends QuizMcqEvent {
  BuildContext context;

  SelectOptionCImage(this.context);
}

class SelectOptionDImage extends QuizMcqEvent {
  BuildContext context;

  SelectOptionDImage(this.context);
}

class CorrectOptionChanged extends QuizMcqEvent {
  final String correctOption;

  CorrectOptionChanged({this.correctOption});
}

class ValidateMCQ extends QuizMcqEvent {}

class ClearFields extends QuizMcqEvent {}
