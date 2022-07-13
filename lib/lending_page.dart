
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'all_customers.dart';

TextEditingController amount = TextEditingController();

class lending_page extends StatefulWidget {

  @override
  State<lending_page> createState() => _MyAppState();
}

void main() {
  runApp(MaterialApp(
    home : lending_page(),
  ));
}

class _MyAppState extends State<lending_page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Give",
          ),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Amount',
                ),
                controller: amount,
              ),
              ElevatedButton
                (onPressed: (){
                final transaction1 = <String, dynamic>{
                  "sender_email": user_email,
                  "reciever_email": openup_user_email,
                  "amount": int.parse(amount.text),
                  "reciever_username" : openup_user_name,
                  "time" :  Timestamp.now()
                };
                final transaction2 = <String, dynamic>{
                  "sender_email": openup_user_email,
                  "reciever_email": user_email,
                  "amount": int.parse("-"+amount.text),
                  "reciever_username" : user_username,
                  "time" :  Timestamp.now()
                };

                db.collection("transactions").add(transaction1);
                db.collection("transactions").add(transaction2);

                appendToArray(user_email,openup_user_name);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Transaction Made")));
                Navigator.pop(context);
                Navigator.pop(context);
              },
                  child: Text(
                    "Lend",
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> appendToArray(String id, dynamic element) async {
  db.collection("users").doc(id).update({
    'customer': FieldValue.arrayUnion([element]),
  });
}
