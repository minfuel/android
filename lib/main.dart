import 'package:home_widget/home_widget.dart';
import 'package:homescreen_widget/pages/edit_messsage.dart';
import 'package:homescreen_widget/pages/langchain.dart';
import 'package:homescreen_widget/pages/send_message.dart';
import 'package:homescreen_widget/pages/send_message_vr0.dart';
import 'package:homescreen_widget/pages/send_message_vr1%20(realtime).dart';
import 'package:flutter/material.dart';
import 'package:homescreen_widget/pocketbase/credentials.dart';
import 'package:homescreen_widget/provider/credentials_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.registerBackgroundCallback(backgroundCallback);
  runApp(const MyApp());
}

// Called when Doing Background Work initiated from Widget
Future<void> backgroundCallback(Uri? uri) async {
  if (uri?.host == 'updatecounter') {
    int counter = 0;
    var city = "horten";
    await HomeWidget.getWidgetData<int>('_counter', defaultValue: 0)
        .then((value) {
      counter = value!;
      counter++;
    });
    await HomeWidget.saveWidgetData<int>('_counter', counter);
    //
    await HomeWidget.getWidgetData<String>('_city', defaultValue: "Sett opp en start by!")
        .then((value) {
      city = value!;
    });
    await HomeWidget.saveWidgetData('_city', city);
    await HomeWidget.updateWidget(
      //this must the class name used in .Kt
        name: 'HomeScreenWidgetProvider',
        iOSName: 'HomeScreenWidgetProvider');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CredentialsProvider()),
      ],
      builder: (context,_) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          home: const MyHomePage(title: 'PocketBase'),
        );
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _city = "Horten";
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    context.read<CredentialsProvider>().getCredentials();
    //
    HomeWidget.widgetClicked.listen((Uri? uri) => loadData());
    loadData(); // This will load data from widget every time app is opened
  }

  void loadData() async {
    await HomeWidget.getWidgetData<int>('_counter', defaultValue: 0)
        .then((value) {
      _counter = value!;
    });
    //
    await HomeWidget.getWidgetData<int>('_city', defaultValue: 0)
        .then((value) {
      _city = value! as String;
    });
    setState(() {});
  }

  Future<void> updateAppWidget() async {
    await HomeWidget.saveWidgetData<int>('_counter', _counter);
    //
    await HomeWidget.saveWidgetData<String>('_city', _city as String?);
    await HomeWidget.updateWidget(
        name: 'HomeScreenWidgetProvider', iOSName: 'HomeScreenWidgetProvider');
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _city = "horten" as String;
    });
    updateAppWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Positioned(child: Center(
            child: ListView(

              children: <Widget>[
                IconButton(onPressed: _incrementCounter, icon: Icon(Icons.add)),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
                ListTile(
                  title: Text('Langchain'),
                  subtitle: Text('local.id'),
                  leading: InkWell(
                      child:  Icon(Icons.online_prediction,color: Colors.teal[400],),
                      onTap: () async {
                        final url = Uri.parse("https://chat.langchain.dev?q=report");
                        if (await canLaunchUrl(url)) {
                          launchUrl(url);
                        } else {
                          // ignore: avoid_print
                          print("Can't launch $url");
                        }
                      }),
                  trailing: InkWell(
                      child:  Icon(Icons.edit,color: Colors.teal[400],),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => LangChainPage()));
                      }),
                  tileColor: Colors.transparent,
                  selectedTileColor: Colors.white,

                ),
                ...context.watch<CredentialsProvider>()
                    .credentials
                    .map((credential) =>
                    Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(credential.server),
                            subtitle: Text(credential.id),
                            leading: InkWell(
                                child:  Icon(Icons.online_prediction,color: Colors.teal[400],),
                                onTap: () async {
                                  final url = Uri.parse(credential.site);
                                  if (await canLaunchUrl(url)) {
                                    launchUrl(url);
                                  } else {
                                    // ignore: avoid_print
                                    print("Can't launch $url");
                                  }
                                }),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                    child:  Icon(Icons.edit,color: Colors.teal[400],),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => EditMessagePage(credential: credential)));
                                    }),
                                VerticalDivider(),
                                InkWell(
                                    child:  Icon(Icons.delete,color: Colors.teal[400],),
                                    onTap: () {
                                      showDialog(context: context, builder: (contextDialog) {
                                        return AlertDialog(
                                          title: Text("Permanent Action!"),
                                          content: Text("Are you sure you want to delete?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(contextDialog);
                                                },
                                                child: Text("Abort")
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  context.read<CredentialsProvider>().deleteCredentialPocketBase(credential.id);
                                                  Navigator.pop(contextDialog);
                                                },
                                                child: Text("Confirm")
                                            ),

                                          ],
                                        );
                                      });
                                    }),
                              ],
                            ),
                            tileColor: Colors.transparent,
                            selectedTileColor: Colors.white,

                          ),
                        ]
                    )
                ).toList(),

                // Add Credential (realtime and/ same page)
                const SendMessagePage()

              ],
            ),
          ),
            top: 0,left:0,right:0,bottom: 100
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => SendMessagePage_vr1()));
        },
        tooltip: 'Send Message',
        child: const Icon(Icons.mark_unread_chat_alt_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

