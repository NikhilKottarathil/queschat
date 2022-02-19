
class LeaderBoardModel{

  String id,quizId,userId,userName,profilePic;
  int correctAnswers,wrongAnswers,totalAttended,completedTime,score;
  DateTime createdTime;

  LeaderBoardModel({
      this.id,
      this.quizId,
      this.userId,
      this.userName,
      this.profilePic,
      this.correctAnswers,
      this.wrongAnswers,
      this.totalAttended,
      this.completedTime,
    this.score,
      this.createdTime});
}