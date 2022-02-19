class MCQModel {
  List<String>fhdh;
  String question,
      optionA,
      optionB,
      optionC,
      optionD,
      correctAnswer,
      selectedAnswer,
      optionType;
  double optionAPercentage = 0,
      optionBPercentage = 0,
      optionCPercentage = 0,
      optionDPercentage = 0;
  List<String> media;

  MCQModel(

      {this.question,
      this.optionA,
      this.optionB,
      this.optionC,
      this.optionD,
      this.correctAnswer,
      this.selectedAnswer,
      this.optionType,
      this.optionAPercentage,
      this.optionBPercentage,
      this.optionCPercentage,
      this.optionDPercentage,
      this.media});
}
