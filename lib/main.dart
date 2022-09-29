// dart async library we will refer to when setting up real time updates
import 'dart:async';

// flutter and ui libraries
import 'package:flutter/material.dart';

// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

// amplify configuration and models that should have been generated for you
import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';
import 'models/Todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Amplified Todo',
      home: HomePage(),
    );
  }
}

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

    // Query and Observe updates to Todo models. DataStore.observeQuery() will
    // emit an initial QuerySnapshot with a list of Todo models in the local store,
    // and will emit subsequent snapshots as updates are made
    //
    // each time a snapshot is received, the following will happen:
    // _isLoading is set to false if it is not already false
    // _todos is set to the value in the latest snapshot
    _subscription = Amplify.DataStore.observeQuery(Todo.classType)
        .listen((QuerySnapshot<Todo> snapshot) {
      setState(() {
        if (_isLoading) _isLoading = false;
        _todos = snapshot.items;
      });
    });
  }

  Future<void> _configureAmplify() async {
    if (Amplify.isConfigured){
      null;
    }
    else{
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
        title: const Text('My Todo List'),
      ),
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
        tooltip: 'Add Todo',
        label: Row(
          children: const [Icon(Icons.add), Text('Add todo')],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 27, 27, 27),
      child: const Center(
        child: Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 27, 27, 27),
      child: const Center(
        child: Text(
          "Analysis",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  _HomePageState createState() => _HomePageState();
}
  
class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  
  final pages = [
    const Page1(),
    const TodosPage(),
    const Page2()
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffC4DFCB),
      appBar: AppBar(
        title: Text(
          "GTRTracker",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: pages[pageIndex],
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 27, 27, 27),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(2, -2),
            ),
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.home_filled,
                      color: Color.fromARGB(255, 43, 121, 194),
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.task_alt_rounded,
                      color: Color.fromARGB(255, 43, 121, 194),
                      size: 35,
                    )
                  : const Icon(
                      Icons.task_alt_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: pageIndex == 2
                  ? const Icon(
                      Icons.timeline_rounded,
                      color: Color.fromARGB(255, 43, 121, 194),
                      size: 35,
                    )
                  : const Icon(
                      Icons.timeline_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodosList extends StatelessWidget {
  const TodosList({
    required this.todos,
    Key? key,
  }) : super(key: key);

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return todos.isNotEmpty
        ? ListView(
            padding: const EdgeInsets.all(8),
            children: todos.map((todo) => TodoItem(todo: todo)).toList())
        : const Center(
            child: Text('Tap button below to add a todo!'),
          );
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({
    required this.todo,
    Key? key,
  }) : super(key: key);

  final double iconSize = 24.0;
  final Todo todo;

  void _deleteTodo(BuildContext context) async {
    try {
      // to delete data from DataStore, we pass the model instance to
      // Amplify.DataStore.delete()
      await Amplify.DataStore.delete(todo);
    } catch (e) {
      print('An error occurred while deleting Todo: $e');
    }
  }

  Future<void> _toggleIsComplete() async {
    // copy the Todo we wish to update, but with updated properties
    final updatedTodo = todo.copyWith(isComplete: !todo.isComplete);
    try {
      // to update data in DataStore, we again pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(updatedTodo);
    } catch (e) {
      print('An error occurred while saving Todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          _toggleIsComplete();
        },
        onLongPress: () {
          _deleteTodo(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(todo.description ?? 'No description'),
                ],
              ),
            ),
            Icon(
                todo.isComplete
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                size: iconSize),
          ]),
        ),
      ),
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

  Future<void> _saveTodo() async {
    // get the current text field contents
    final name = _nameController.text;
    final description = _descriptionController.text;

    // create a new Todo from the form values
    // `isComplete` is also required, but should start false in a new Todo
    final newTodo = Todo(
      name: name,
      description: description.isNotEmpty ? description : null,
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
        title: const Text('Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(filled: true, labelText: 'Name'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    filled: true, labelText: 'Description'),
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
