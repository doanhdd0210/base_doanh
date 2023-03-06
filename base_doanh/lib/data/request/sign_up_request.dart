class SignUpRequest {
  String username;
  String email;
  String password;

  SignUpRequest({required this.username, required this.email, required this.password});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] =email;
    data['password'] = password;
    return data;
  }
}