import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "To-Do",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

late TextEditingController controller;

List thingsToDo = [
  "Paint the front house and the living room sweet for the rest to come home",
  "Build the bath room",
  "Repaint rain gutters",
];

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit(text) {
    if (text.isEmpty || text == null) return;
    setState(() {
      thingsToDo.add(text);
    });
    Navigator.of(context).pop();
    print(thingsToDo);
  }

  Future openDialog() => showDialog<String>(
      context: context,
      builder: ((context) => AlertDialog(
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration:
                  InputDecoration(hintText: "Enter something to-do later! "),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    submit(controller.value.text);
                    controller.clear();
                  },
                  child: Text("Submit"))
            ],
          )));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Things To-Do"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: thingsToDo.map((item) {
              return Card(
                  child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250,
                      child: Text(
                        item,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {},
                        icon: Icon(Icons.cancel_outlined))
                  ],
                ),
              ));
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog();
        },
        tooltip: 'Add to-do',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
