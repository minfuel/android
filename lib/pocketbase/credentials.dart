import 'package:homescreen_widget/models/request/credential.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:homescreen_widget/models/credential.dart';
PocketBase client = PocketBase('https://analytics.minfuel.com');


class MyPocketBase {
  static Future getCredentials() async {
    final client_ = PocketBase('https://analytics.minfuel.com');
    final authData = client_.admins.authWithPassword(
        "minfuelteam@gmail.com", "thWgM3p7d39sG43");

    return await client_.collection('credentials').getFullList(
        batch: 200, sort: '-created');
  }

  static Future addCredential(CredentialRequest credential) async {
    return await client.collection('credentials').create(
        body: credential.toJson());
  }

  static Future updateCredential(CredentialRequest credential, String id) async {
    return await client.collection('credentials').update(
        id,
        body: credential.toJson());
  }


  static Future deleteCredential(String id) async {
    return await client.collection('credentials').delete(id);
  }

  static Future<RealtimeService> realtime() async {
    return  client.realtime;
  }
}