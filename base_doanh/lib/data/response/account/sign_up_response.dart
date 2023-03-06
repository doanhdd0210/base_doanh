class SignUpResponse {
  DataSignUpResponse? data;
  int? statusCode;

  SignUpResponse({this.data, this.statusCode});

  SignUpResponse.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? DataSignUpResponse.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
  }
}

class DataSignUpResponse {
  String? username;
  String? email;
  String? password;
  String? id;

  DataSignUpResponse({this.username, this.email, this.password, this.id});

  DataSignUpResponse.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
    id = json['id'];
  }
}
