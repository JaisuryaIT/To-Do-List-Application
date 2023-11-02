import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

enum TaskType {
  work,
  study,
  general,
}

class Task {
  String name;
  String description;
  TaskType type;
  DateTime date;
  TimeOfDay time;

  Task({
    required this.name,
    required this.description,
    required this.type,
    required this.date,
    required this.time,
  });
}

class Profile {
  String name;

  Profile({
    required this.name,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black87,
        // backgroundColor: Colors.black87,

        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'To-Do List',
        profile: Profile(
          name: 'Jaisurya',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, required this.profile})
      : super(key: key);

  final String title;
  final Profile profile;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> _tasks = [];
  void _addTask(
    String taskName,
    String taskDescription,
    TaskType taskType,
    DateTime taskDate,
    TimeOfDay taskTime,
  ) {
    setState(() {
      _tasks.add(
        Task(
          name: taskName,
          description: taskDescription,
          type: taskType,
          date: taskDate,
          time: taskTime,
        ),
      );
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _showAddTaskDialog() async {
    String newTaskName = '';
    String newTaskDescription = '';
    TaskType newTaskType = TaskType.general;
    DateTime newTaskDate = DateTime.now();
    TimeOfDay newTaskTime = TimeOfDay.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Task Name',
                ),
                onChanged: (value) {
                  newTaskName = value;
                },
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Task Description',
                ),
                onChanged: (value) {
                  newTaskDescription = value;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<TaskType>(
                value: newTaskType,
                decoration: InputDecoration(
                  labelText: 'Task Type',
                ),
                items: TaskType.values.map((type) {
                  return DropdownMenuItem<TaskType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  newTaskType = value!;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      child: Text(
                        DateFormat('EEEE, MMMM d, yyyy').format(newTaskDate),
                      ),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: newTaskDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null && picked != newTaskDate) {
                          setState(() {
                            newTaskDate = picked;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      child: Text(
                        newTaskTime.format(context),
                      ),
                      onPressed: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: newTaskTime,
                        );
                        if (picked != null && picked != newTaskTime) {
                          setState(() {
                            newTaskTime = picked;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                _addTask(
                  newTaskName,
                  newTaskDescription,
                  newTaskType,
                  newTaskDate,
                  newTaskTime,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 63, 62, 57),
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: ListTile(
          leading: CircleAvatar(
            radius: 25,
            child: Image.asset('assets/batman.png'),
          ),
          title: Text(
            'Welcome',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          subtitle: const Text(
            "Jaisurya",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_month_sharp)),
                IconButton(
                    onPressed: () {}, icon: const Icon(CupertinoIcons.bell))
              ],
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 63, 62, 57),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Text('JS005',
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.profile.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home_filled),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help Center'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpCenterPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About This App'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _removeTask(index);
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 24.0),
              color: Colors.red,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Container(
              color: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    _tasks[index]
                        .type
                        .toString()
                        .split('.')
                        .last
                        .substring(0, 1)
                        .toUpperCase(),
                  ),
                ),
                title: Text(
                  _tasks[index].name,
                  selectionColor: Colors.amber,
                ),
                subtitle: Text(_tasks[index].description),
                trailing: Text(
                  '${DateFormat('h:mm a').format(DateTime(1, 1, 1, _tasks[index].time.hour, _tasks[index].time.minute))}\n${DateFormat('EEEE, MMMM d').format(_tasks[index].date)}',
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}

class HelpCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: ListTile(
          leading: Icon(
            Icons.help,
            size: 40,
          ),
          title: Text(
            'HelpCenter',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'If you need help, feel free to contact us:',
              style: TextStyle(fontSize: 25, color: Colors.cyan),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => launch('tel:+919342742293'),
            icon: Icon(Icons.phone),
            label: Text('Call us'),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => launch('jaisuryait22@bitsathy.ac.in'),
            icon: Icon(Icons.email),
            label: Text('Email us'),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: ListTile(
          leading: Icon(
            Icons.info,
            size: 40,
          ),
          title: Text(
            'About this App',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'A to-do application is a type of productivity app that helps users keep track of tasks they need to complete. With a to-do app, users can create lists of tasks, set deadlines, categorize tasks, and mark tasks as completed. These apps can be used for personal or professional purposes, and they can help users stay organized and manage their time more efficiently.',
                style: TextStyle(fontSize: 25, color: Colors.cyan),
              )),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => launch('https://www.g2.com/glossary/to-do-lists'),
            icon: Icon(Icons.info),
            label: Text('Click here for More information about this app'),
          ),
        ],
      ),
    );
  }
}
