class LoginModel {
  String? sId;
  String? phoneNumber;
  String? email;
  String? token;

  LoginModel({this.sId, this.phoneNumber, this.email, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['token'] = this.token;
    return data;
  }
}
