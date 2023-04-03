import 'dart:convert';
import 'package:homescreen_widget/models/request/credential.dart';
import 'package:flutter/services.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter/foundation.dart';
import 'package:homescreen_widget/pocketbase/credentials.dart';
import 'package:homescreen_widget/models/credential.dart';


class CredentialsProvider with ChangeNotifier{

  CredentialsProvider(){
    realtime();
  }
   List<Credential> _credentials = [];

  List<Credential> get credentials => _credentials;

  void addCredential(Credential credential) {
    _credentials.add(credential);
    notifyListeners();
  }
  void updateCredential(Credential credential){
    _credentials[_credentials.indexWhere((element) => element.id == credential.id)] = credential;
    notifyListeners();
  }
  void deleteCredential(Credential credential){
    _credentials.removeWhere((element) => element.id == credential.id);
    notifyListeners();
  }



  getCredentials() async {
    List<RecordModel> result = await MyPocketBase.getCredentials();
    result.map((credential) {
      credential.data['id'] = credential.id;
      Credential _credential = Credential.fromJson(credential.data);
      addCredential(_credential);
    }).toList();
    notifyListeners();
  }
   Future<void> addCredentialPocketBase(String server, String site, String token) async {
     CredentialRequest credential = CredentialRequest(server: server, site: site, token: token);
     await MyPocketBase.addCredential(credential);
     //RecordModel result = await MyPocketBase.addCredential(credential);
     //print(result.data);
     //addCredential(Credential.fromJson(result.data));

   }
  Future<void> updateCredentialPocketBase(String server, String site, String token, String id) async {
    CredentialRequest credential = CredentialRequest(server: server, site: site, token: token);
    await MyPocketBase.updateCredential(credential, id);
    //RecordModel result = await MyPocketBase.addCredential(credential);
    //print(result.data);
    //addCredential(Credential.fromJson(result.data));

  }
  Future<void> deleteCredentialPocketBase(String id) async {
    await MyPocketBase.deleteCredential(id);
    //RecordModel result = await MyPocketBase.addCredential(credential);
    //print(result.data);
    //addCredential(Credential.fromJson(result.data));

  }
  Future<void> realtime() async {
    //RealtimeService response = await MyPocketBase.realtime();

    //response.subscribe('*', (SseMessage event) {
    client.collection('credentials').subscribe("*", (event) {
        print(event.action); // create, update, delete
      switch (event.action){
        case 'create':
          event.record!.data['id'] = event.record!.id;
          addCredential(Credential.fromJson(event.record!.data));
          break;
        case 'update':
          event.record!.data['id'] = event.record!.id;
          updateCredential(Credential.fromJson(event.record!.data));
          break;
        case 'delete':
          event.record!.data['id'] = event.record!.id;
          deleteCredential(Credential.fromJson(event.record!.data));
          break;
      }
    });
  }



}