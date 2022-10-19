import 'dart:async';
import 'dart:collection';

// flutter and ui libraries
import 'package:flutter/material.dart';

// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gtrtracker/models/Todo.dart';

// amplify configuration and models that should have been generated for you

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  final _dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);
  final AmplifyAPI _apiPlugin = AmplifyAPI();
  void initState() {
    // kick off app initialization
    readFromDatabase();

    super.initState();
  }

  late StreamSubscription<QuerySnapshot<Todo>> _subscription;
  bool _isLoading = true;
  List<Todo> _todos = [];

  Future<void> readFromDatabase() async {
    if (Amplify.isConfigured) {
      null;
    } else {
      await Amplify.addPlugins([_dataStorePlugin, _apiPlugin]); //, _authPlugin
    }
    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    } on AmplifyException catch (e) {
      throw AmplifyException(e.message);
    }
    _subscription = Amplify.DataStore.observeQuery(Todo.classType)
        .listen((QuerySnapshot<Todo> snapshot) {
      if (mounted) {
        setState(() {
          if (_isLoading) _isLoading = false;
          _todos = snapshot.items;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 27, 27, 27),
          title: Text("Home",
              style: TextStyle(color: Color.fromARGB(255, 43, 121, 194))),
        ),
        backgroundColor: Color.fromARGB(255, 27, 27, 27),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(children: <Widget>[
                Center(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Current Goals',
                              style: GoogleFonts.roboto(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            )))),
                const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                    )),
                ListTileTheme(
                  contentPadding: const EdgeInsets.all(8),
                  iconColor: Color.fromARGB(255, 0, 0, 0),
                  textColor: Color.fromARGB(255, 0, 0, 0),
                  tileColor: Color.fromARGB(255, 255, 255, 255),
                  style: ListTileStyle.list,
                  dense: true,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                        shape: border,
                        trailing: Icon(Icons.more_vert),
                        title: Text(
                          _todos[index].name,
                          textScaleFactor: 1.5,
                          style: GoogleFonts.roboto(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(goal: _todos[index]),
                            ),
                          );
                        },
                      ));
                    },
                  ),
                )
              ])));
  }
}
