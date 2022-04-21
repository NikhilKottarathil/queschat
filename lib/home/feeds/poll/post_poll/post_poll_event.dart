import 'package:flutter/cupertino.dart';

abstract class PostPollEvent {}

class NumberOfOptionChanged extends PostPollEvent {

}
class QuestionChanged extends PostPollEvent {
  final String question;

  QuestionChanged({this.question});
}

class SelectQuestionImages extends PostPollEvent {
  BuildContext context;

  SelectQuestionImages({this.context});
}
class ChooseOptionType extends PostPollEvent {

}
class OptionAChanged extends PostPollEvent {
  final String optionA;

  OptionAChanged({this.optionA});
}

class OptionBChanged extends PostPollEvent {
  final String optionB;

  OptionBChanged({this.optionB});
}

class OptionCChanged extends PostPollEvent {
  final String optionC;

  OptionCChanged({this.optionC});
}

class OptionDChanged extends PostPollEvent {
  final String optionD;

  OptionDChanged({this.optionD});
}

class CorrectOptionChanged extends PostPollEvent {
  final String correctOption;

  CorrectOptionChanged({this.correctOption});
}




class SelectOptionAImage extends PostPollEvent {
  BuildContext context;
  SelectOptionAImage(this.context);
}

class SelectOptionBImage extends PostPollEvent {
  BuildContext context;
  SelectOptionBImage(this.context);
}

class SelectOptionCImage extends PostPollEvent {
  BuildContext context;
  SelectOptionCImage(this.context);
}

class SelectOptionDImage extends PostPollEvent {
  BuildContext context;
  SelectOptionDImage(this.context);
}

class PostPollSubmitted extends PostPollEvent {}

class ClearAllFields extends PostPollEvent {}
