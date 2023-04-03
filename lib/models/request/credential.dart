import 'dart:convert';


class CredentialRequest {
  final String server;
  final String site;
  final String token;

  CredentialRequest({required this.server, required this.site, required this.token});

  factory CredentialRequest.fromJson(Map<String, dynamic> json) {
    return CredentialRequest(
        server: json["server"],
        site: json['site'],
        token: json['token']
    );
  }

  Map<String,dynamic> toJson() {
    return {
      'server': server,
      'site': site,
      'token': token,
    };
  }

}