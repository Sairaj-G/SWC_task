import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swc_task/open_up_profile.dart';

void main() {
  runApp(MaterialApp(
    home : all_customers(),
  ));
}
String openup_user_email = "";
String openup_user_name = "";

class all_customers extends StatefulWidget {
  @override
  State<all_customers> createState() => _MyAppState();
}


class _MyAppState extends State<all_customers> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Add Customer",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          shadowColor: Colors.blueAccent,
          backgroundColor: Colors.blueAccent,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['username']),
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(5),
                ),
                  onTap: (){
                    openup_user_email = data['email'];
                    openup_user_name = data['username'];
                    Navigator.push(context, MaterialPageRoute(builder: (context) => open_up_profile()));
                  },
                );
              }).toList(),
            );
          },
        ),
      ),

    );
  }
}
