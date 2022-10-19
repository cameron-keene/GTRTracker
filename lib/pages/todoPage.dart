import 'dart:async';

// flutter and ui libraries
import 'package:flutter/material.dart';

// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:permission_handler/permission_handler.dart';

// amplify configuration and models that should have been generated for you
import 'package:gtrtracker/amplifyconfiguration.dart';
import 'package:gtrtracker/models/ModelProvider.dart';
import 'package:gtrtracker/todoClass/todo.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  // subscription of Todo QuerySnapshots - to be initialized at runtime
  late StreamSubscription<QuerySnapshot<Todo>> _subscription;

  // loading ui state - initially set to a loading state
  bool _isLoading = true;

  // list of Todos - initially empty
  List<Todo> _todos = [];

  // amplify plugins
  final _dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);
  final AmplifyAPI _apiPlugin = AmplifyAPI();
  // final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();
  @override
  void initState() {
    // kick off app initialization
    _initializeApp();

    super.initState();
  }

  @override
  void dispose() {
    // to be filled in a later step
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // configure Amplify
    await _configureAmplify();
    await requestPermission();

    // Query and Observe updates to Todo models. DataStore.observeQuery() will
    // emit an initial QuerySnapshot with a list of Todo models in the local store,
    // and will emit subsequent snapshots as updates are made
    //
    // each time a snapshot is received, the following will happen:
    // _isLoading is set to false if it is not already false
    // _todos is set to the value in the latest snapshot
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

  Future<void> requestPermission() async {
    await Permission.location.request();
  }

  Future<void> _configureAmplify() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 27, 27, 27),
        title: const Text('Goals',
            style: TextStyle(color: Color.fromARGB(255, 43, 121, 194))),
      ),
      backgroundColor: Color.fromARGB(255, 27, 27, 27),
      // body: const Center(child: CircularProgressIndicator()),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TodosList(todos: _todos),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoForm()),
          );
        },
        tooltip: 'Add Goal',
        label: Row(
          children: const [Icon(Icons.add), Text('Add Goal')],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class AddTodoForm extends StatefulWidget {
  const AddTodoForm({Key? key}) : super(key: key);

  @override
  State<AddTodoForm> createState() => _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _goalDurationController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> _saveTodo() async {
    // get the current text field contents
    final name = _nameController.text;
    final description = _descriptionController.text;
    final goalDuration = int.parse(_goalDurationController.text);
    final location = double.parse(_addressController
        .text); //TODO: function to extract latitude and longitude

    // create a new Todo from the form values
    // `isComplete` is also required, but should start false in a new Todo
    final newTodo = Todo(
      name: name,
      description: description.isNotEmpty ? description : null,
      goalDuration: goalDuration,
      currentDuration: 0,
      latitude: location, //TODO: change
      longitude: location, //TODO: change
      isComplete: false,
    );

    try {
      // to write data to DataStore, we simply pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(newTodo);

      // after creating a new Todo, close the form
      Navigator.of(context).pop();
    } catch (e) {
      print('An error occurred while saving Todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Goal'),
      ),
      backgroundColor: Color.fromARGB(255, 27, 27, 27),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Description',
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
              ),
              TextFormField(
                controller: _goalDurationController,
                decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Goal Duration',
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                    filled: true,
                    labelText: 'address',
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
              ),
              ElevatedButton(
                onPressed: _saveTodo,
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
