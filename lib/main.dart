import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class Exam {
  late String name;
  late DateTime date;
  late TimeOfDay time;
  late Key key;

  Exam(String name, DateTime date, TimeOfDay time) {
    this.name = name;
    this.date = date;
    this.time = time;
    this.key = Key(name);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 3',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var appTitle = '201117';
  var examList = [];
  bool toggleForm = false;

  final _inputKey = GlobalKey<FormState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  String name = "";
  DateTime currentDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  late TextEditingController txt;

  @override
  void initState() {
    super.initState();
    txt = TextEditingController()
      ..addListener(() {
      });
  }

  @override
  void dispose() {
    txt.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(context: context, initialDate: currentDate, firstDate: DateTime(2015), lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      title: '201117',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  toggleForm = !toggleForm;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  toggleForm = false;
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              if (toggleForm)
                Card(
                    elevation: 5,
                    child: Form(
                      key: _inputKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(15),
                              child: TextFormField(
                                  controller: txt,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.book_outlined),
                                    hintText: 'Name of the exam',
                                    labelText: 'Exam name *',
                                  ),
                                  validator: (inputString) {
                                    name = inputString!;
                                    if (inputString.length < 1) {
                                      return 'Please enter a valid name';
                                    }
                                    return null;
                                  })),
                          Padding(
                            padding: EdgeInsets.all(1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(padding: EdgeInsets.all(20), child: Text(currentDate.toString().split(" ")[0])),
                                ElevatedButton(
                                  onPressed: () => _selectDate(context),
                                  child: Text('Select date'),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(padding: EdgeInsets.all(20), child: Text(selectedTime.format(context))),
                                ElevatedButton(
                                  onPressed: () => _selectTime(context),
                                  child: Text('Select time'),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_inputKey.currentState!.validate()) {
                                  name = txt.text;
                                  examList.add(new Exam(name, currentDate, selectedTime));
                                  setState(() {
                                    this.examList = examList;
                                    txt.text = "";
                                    name = "";
                                    currentDate = DateTime.now();
                                    selectedTime = TimeOfDay.now();
                                  });
                                  _messangerKey.currentState?.showSnackBar(SnackBar(content: Text('Exam added successfully')));
                                }
                              },
                              child: const Text('Add'),
                            ),
                          ),
                        ],
                      ),
                    )),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: examList.length,
                itemBuilder: (contx, index) {
                  return Column(children: [
                    Card(
                      key: examList[index].key,
                      elevation: 2,
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(18),
                        child: Column(children: [
                          Container(padding: EdgeInsets.all(5), margin: EdgeInsets.all(5), child: Text(examList[index].name, style: TextStyle(fontWeight: FontWeight.bold))),
                          Container(padding: EdgeInsets.all(5), margin: EdgeInsets.all(5), child: Text(examList[index].date.toString().split(" ")[0] + " " + examList[index].time.format(context), style: TextStyle(color: Colors.grey))),
                        ]),
                      ),
                    ),
                  ]);
                },
              ),
            ])),
      ),
    );
  }
}
