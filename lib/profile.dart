

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';


class Profile extends StatefulWidget {

  @override
  State<Profile> createState() => _MyAppState();
}

void main() {
  runApp(MaterialApp(
      home : Profile()
  ));
}

class _MyAppState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  child: Icon(Icons.person,
                    size: 60.0,
                  ),
                  radius: 50.0,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Username: " + user_username,
                style: TextStyle(
                  fontSize: 30.0
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                  style: TextStyle(
                      fontSize: 30.0
                  ),
                  "Email: " + user_email,
              ),

            ],

          ),
        ),
      ),
    );
  }
}
