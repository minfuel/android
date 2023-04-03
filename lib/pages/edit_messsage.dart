import 'package:flutter/material.dart';
import 'package:homescreen_widget/models/credential.dart';
import 'package:homescreen_widget/provider/credentials_provider.dart';
import 'package:provider/provider.dart';

class EditMessagePage extends StatefulWidget {
  Credential credential;

  EditMessagePage({Key? key, required this.credential}) : super(key: key);

  @override
  State<EditMessagePage> createState() => _EditMessagePageState();
}

class _EditMessagePageState extends State<EditMessagePage> {
  TextEditingController _serverController = TextEditingController();
  TextEditingController _siteController = TextEditingController();
  TextEditingController _tokenController = TextEditingController();

  @override
  void initState() {
    _serverController.text = widget.credential.server;
    _siteController.text = widget.credential.site;
    _tokenController.text = widget.credential.token;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Message'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Edit A Credential:'),
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
                context.read<CredentialsProvider>().updateCredentialPocketBase(
                    _serverController.text,
                    _siteController.text,
                    _tokenController.text,
                    widget.credential.id
                );
                Navigator.pop(context);
                //_serverController.clear();
                //_siteController..clear();
                //_tokenController..clear();


              }, child: const Text('Send'))

            ],

          ),
        ),
      ),
    );
  }
}
