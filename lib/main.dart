import 'package:flutter/material.dart';
import '../db/db_provider.dart';
import 'model/task_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyTodoApp(),
    );
  }
}

class MyTodoApp extends StatefulWidget{
  @override
  _MyTodoAppState createState() => _MyTodoAppState();
}

class _MyTodoAppState extends State<MyTodoApp> {
  Color mainColor=Color(0xFFFFCA28);
  TextEditingController inputController = TextEditingController();
  String newTaskTxt="";
  getTasks() async{
    final tasks=await DBProvider.dataBase.getTask();
    print(tasks);
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: mainColor,
        title: Text("My To-Do List!", style: TextStyle(
          fontSize: 23.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        )
        ),
      ),
      backgroundColor: mainColor,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getTasks(),
              builder: (_,taskData) {
                switch(taskData.connectionState)
                {
                  case ConnectionState.waiting:
                    {
                      return Center(child: CircularProgressIndicator());
                    }
                  case ConnectionState.done:
                    {
                      if(taskData.data != Null)
                      {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: taskData.data.length,
                            itemBuilder: (context,index){
                              String task=taskData.data[index]['task'].toString();
                              String day=DateTime.parse(taskData.data[index]['creationDate']).day.toString();
                              return Card(
                                color: Colors.white12,
                                child: InkWell(
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 12.0),
                                        padding: EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Text(
                                          day,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                          )
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                          task,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            )
                                          )
                                        )
                                      )
                                   ] //children
                                  ),
                                )
                             );
                            }
                          ),
                        );
                       } else {
                        return Center(
                          child: Text("You Have No Tasks Today",
                            style: TextStyle(
                              color: Colors.black
                            ),
                          ),
                        );
                      }
                    }
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            decoration: BoxDecoration(
                color: Colors.black54,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              )
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Type a new Task",
                    ),
                  ),
                ),
                SizedBox(width: 15,
                ),
                FlatButton.icon(
                  icon: Icon(Icons.add, color: Colors.black),
                  label: Text("Add Task"),
                  color: Colors.white,
                  shape: StadiumBorder(),
                  textColor: Colors.black,
                  onPressed: () {
                    //function that inserts the data into the table
                    setState(() {
                      newTaskTxt=inputController.text.toString();
                      inputController.text="";
                    });
                    Task newTask=Task(task: newTaskTxt, dateTime: DateTime.now());
                    DBProvider.dataBase.addNewTask(newTask);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}