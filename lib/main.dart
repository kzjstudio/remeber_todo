import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
var date = DateTime.now().obs;

List thingsToDo = [
  {
    "date": date,
    "todo":
        "Paint the front house and the living room sweet for the rest to come home"
  },
  {"date": date, "todo": "Build the bath room"},
  {"date": date, "todo": "Repaint rain gutters"},
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
      thingsToDo.add({"date": date, "todo": text});
    });
    Navigator.of(context).pop();
    print(thingsToDo);
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  void openDatePicker() async {
    DateTime? dateSelected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));

    if (dateSelected == null) return;
    date.value = dateSelected;

    print(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Things To-Do"),
      ),
      body: thingsToDo.isEmpty
          ? const Center(
              child: Text(
                "Please add somthing to remember!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: thingsToDo.map((item) {
                    return Card(
                        child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(convertDateTimeDisplay(item["date"].toString())),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 250,
                                child: Text(
                                  item["todo"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      thingsToDo.remove(item);
                                    });
                                  },
                                  icon: Icon(Icons.check))
                            ],
                          ),
                        ],
                      ),
                    ));
                  }).toList(),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(AlertDialog(
            title: Obx(() => Text(convertDateTimeDisplay(date.string))),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration:
                  InputDecoration(hintText: "Enter something to-do later! "),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    openDatePicker();
                  },
                  child: Text("Pick Date")),
              TextButton(
                  onPressed: () {
                    submit(controller.value.text);
                    controller.clear();
                  },
                  child: Text("Submit"))
            ],
          ));
        },
        tooltip: 'Add to-do',
        child: const Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
