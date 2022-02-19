class QuizModel{
  String heading,content,noOfQuestions;
  List<String> images;
  List<String> mcqIDs;
  int duration;
  String point;
  bool isQuizAttended;

  QuizModel({this.heading,this.isQuizAttended,this.content,this.images,this.noOfQuestions,this.mcqIDs,this.duration,this.point});
}