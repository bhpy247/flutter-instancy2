class LikeDislikeListResponse {
  int userID = 0;
  String userThumb = "";
  String userName = "";
  String userDesg = "";
  String userAddress = "";
  String notifyMsg = "";
  bool check = false;

  LikeDislikeListResponse({this.userID = 0, this.userThumb = "", this.userName = "", this.userDesg = "", this.userAddress = "", this.notifyMsg = "", this.check = false});

  LikeDislikeListResponse.fromMap(Map<String, dynamic> json) {
    userID = json['UserID'];
    userThumb = json['UserThumb'];
    userName = json['UserName'];
    userDesg = json['UserDesg'];
    userAddress = json['UserAddress'];
    notifyMsg = json['NotifyMsg'];
    check = json['check'];
  }

  Map<String, dynamic> toMp() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    data['UserThumb'] = userThumb;
    data['UserName'] = userName;
    data['UserDesg'] = userDesg;
    data['UserAddress'] = userAddress;
    data['NotifyMsg'] = notifyMsg;
    data['check'] = check;
    return data;
  }
}
