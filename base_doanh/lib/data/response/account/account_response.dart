class AccountResponse {
  DataAccountResponse? data;
  int? status;

  AccountResponse({this.data, this.status});

  AccountResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? DataAccountResponse.fromJson(json['data'])
        : null;
    status = json['statusCode'];
  }

}

class DataAccountResponse {
  String? accessToken;
  int? expiresIn;
  num? refreshExpiresIn;
  String? refreshToken;
  String? tokenType;
  int? notBeforePolicy;
  String? sessionState;
  String? scope;
  String? id;
  String? email;

  DataAccountResponse({
    this.accessToken,
    this.expiresIn,
    this.refreshExpiresIn,
    this.refreshToken,
    this.tokenType,
    this.notBeforePolicy,
    this.sessionState,
    this.scope,
    this.id,
    this.email,
  });

  DataAccountResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    refreshExpiresIn = json['refresh_expires_in'];
    refreshToken = json['refresh_token'];
    tokenType = json['token_type'];
    notBeforePolicy = json['not-before-policy'];
    sessionState = json['session_state'];
    scope = json['scope'];
    id = json['id'];
    email = json['email'];
  }

}
