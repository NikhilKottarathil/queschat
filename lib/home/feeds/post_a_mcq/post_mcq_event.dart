abstract class PostMcqEvent {}

class QuestionChanged extends PostMcqEvent {
  final String question;

  QuestionChanged({this.question});
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


class PostMcqSubmitted extends PostMcqEvent {}
class ClearAllFields extends PostMcqEvent {}
