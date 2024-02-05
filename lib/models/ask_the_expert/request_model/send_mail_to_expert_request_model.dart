class SendMailToExpertRequestModel {
  int intUserID;
  int intSiteID;
  int intQuestionID;
  String Questionskills;
  String userQuestion;

  SendMailToExpertRequestModel({
    this.intUserID = 0,
    this.intSiteID = 0,
    this.intQuestionID = 0,
    this.Questionskills = "-1",
    this.userQuestion = "",
  });

  Map<String, String> toJson() {
    return {
      "UserID": intUserID.toString(),
      "intSiteID": intSiteID.toString(),
      "intQuestionID": intQuestionID.toString(),
      "Questionskills": Questionskills,
      "userQuestion": userQuestion,
      "MailSubject": "Question from user"
    };
  }
}
