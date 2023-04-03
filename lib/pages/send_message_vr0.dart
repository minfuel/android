import 'package:homescreen_widget/provider/credentials_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendMessagePage_vr0 extends StatelessWidget {
  const SendMessagePage_vr0({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _serverController = TextEditingController();
    TextEditingController _siteController = TextEditingController();
    TextEditingController _tokenController = TextEditingController();


    return Scaffold(
      appBar: AppBar(title: Text('chat'),),
      body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('original chat (from/ page_vr0):'),
             TextFormField(
               controller: _serverController,
               decoration:  InputDecoration(
                 fillColor: Colors.teal.withAlpha(60),
                     filled: true
               ),
             ),
              TextFormField(

                controller: _siteController,
                decoration:  InputDecoration(
                    fillColor: Colors.teal.withAlpha(60),
                    filled: true
                ),
              ),
              TextFormField(
                controller: _tokenController,
                decoration:  InputDecoration(
                    fillColor: Colors.teal.withAlpha(60),
                    filled: true
                ),
              ),
              ElevatedButton(onPressed: () {
                print(_serverController.text);
                print(_siteController.text);
                print(_tokenController.text);
                context.read<CredentialsProvider>().addCredentialPocketBase(
                    _serverController.text,
                    _siteController.text,
                    _tokenController.text
                );
                _serverController.clear();
                _siteController..clear();
                _tokenController..clear();


              }, child: const Text('Send'))

            ],

      ),
    ),
    );
  }
}
