import 'package:flutter/cupertino.dart';

abstract class PostMcqEvent {}

class QuestionChanged extends PostMcqEvent {
  final String question;

  QuestionChanged({this.question});
}

class SelectQuestionImages extends PostMcqEvent {
  BuildContext context;

  SelectQuestionImages({this.context});
}
class ChooseOptionType extends PostMcqEvent {

}
class OptionAChanged extends PostMcqEvent {
  final String optionA;

  OptionAChanged({this.optionA});
}

class OptionBChanged extends PostMcqEvent {
  final String optionB;

  OptionBChanged({this.optionB});
}

class OptionCChanged extends PostMcqEvent {
  final String optionC;

  OptionCChanged({this.optionC});
}

class OptionDChanged extends PostMcqEvent {
  final String optionD;

  OptionDChanged({this.optionD});
}

class CorrectOptionChanged extends PostMcqEvent {
  final String correctOption;

  CorrectOptionChanged({this.correctOption});
}




class SelectOptionAImage extends PostMcqEvent {
  BuildContext context;
  SelectOptionAImage(this.context);
}

class SelectOptionBImage extends PostMcqEvent {
  BuildContext context;
  SelectOptionBImage(this.context);
}

class SelectOptionCImage extends PostMcqEvent {
  BuildContext context;
  SelectOptionCImage(this.context);
}

class SelectOptionDImage extends PostMcqEvent {
  BuildContext context;
  SelectOptionDImage(this.context);
}

class PostMcqSubmitted extends PostMcqEvent {}

class ClearAllFields extends PostMcqEvent {}
