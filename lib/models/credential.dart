import 'dart:convert';


class Credential {
  final String id;
  final String server;
  final String site;
  final String token;

  Credential({required this.id, required this.server, required this.site, required this.token});

  factory Credential.fromJson(Map<String, dynamic> json) {
    return Credential(
        id: json["id"],
      server: json["server"],
      site: json['site'],
      token: json['token']
    );
  }

  Map<String,dynamic> toJson() {
    return {
      'id': id,
      'server': server,
      'site': site,
      'token': token,
    };
  }

}