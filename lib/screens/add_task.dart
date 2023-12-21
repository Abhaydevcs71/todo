import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addTAskToFirebase() async {
    // FirebaseAuth auth = FirebaseAuth.instance;

    // Get Current user
    final User? user = FirebaseAuth.instance.currentUser;

    //Get user id
    String uid = user!.uid;

    //Get current time
    var time = DateTime.now();

    //adding data to firestore
    CollectionReference tasks = FirebaseFirestore.instance.collection('task');
    // .doc(uid)
    // .collection('mytask')
    // .doc(time.toString());
    tasks.add({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': time.toString(),
      'userId': uid
    });
    Fluttertoast.showToast(msg: 'Succesfully Added');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                    labelText: 'Enter Task Name', border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText: 'Enter Description',
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: () async {
                    await addTAskToFirebase();
                  },
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.green; //add primary color with shade 100
                    return Colors.purple;
                  })),
                  child: Text(
                    'Add Task',
                    style: GoogleFonts.roboto(fontSize: 18),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
