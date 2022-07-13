

import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swc_task/all_customers.dart';
import 'package:swc_task/lending_page.dart';
import 'package:swc_task/open_up_profile.dart';
import 'main.dart';
import 'profile.dart';

class home_page extends StatefulWidget {

  @override
  State<home_page> createState() => _MyAppState();
}


void main() {
  runApp(MaterialApp(
    home : home_page()
  ));
}

class _MyAppState extends State<home_page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: GestureDetector(
            onLongPress: (){
              _signOut();
              Navigator.pop(context);
            },
          ),
          title: Text(
            user_username,
          ),
          actions: [
            IconButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile()));
            }, icon: Icon(Icons.person)),
          ]
        ),
        body: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("transactions").where('sender_email', isEqualTo: user_email).snapshots(),
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
                    title: Text(data['reciever_username']),
                    subtitle:  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('transactions').where('sender_email', isEqualTo: user_email).where('reciever_email', isEqualTo: data['reciever_email'])
                          .get(),
                      builder:
                          (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
                        double sumTotal = 0.0;

                        if (querySnapshot.hasError) {
                          return Text("Something went Wrong");
                        }

                        if (!querySnapshot.hasData ) {
                          return Text("Loading");
                        }

                        if (querySnapshot.connectionState == ConnectionState.done) {
                          querySnapshot.data!.docs.forEach((doc) {
                            sumTotal = sumTotal + doc['amount'] ;
                          });
                          String keyword = sumTotal > 0 ? "To recieve" : "To give";
                          sumTotal = sumTotal >= 0 ? sumTotal : -sumTotal;
                          return Text(keyword + " " + sumTotal.toString());
                        }

                        return Text("loading");
                      },
                    ),
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onTap: (){
                      openup_user_email = data['reciever_email'];
                      openup_user_name = data['reciever_username'];
                      Navigator.push(context, MaterialPageRoute(builder: (context) => open_up_profile()));
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => all_customers()));
          },
          backgroundColor: Colors.green,
          child: Text(
            "Add",
          )
        ),

        ),
    );
  }
}

Future <void> _signOut ()  async{
  await FirebaseAuth.instance.signOut();
}