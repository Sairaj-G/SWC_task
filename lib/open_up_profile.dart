

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swc_task/lending_page.dart';
import 'main.dart';
import 'all_customers.dart';


class open_up_profile extends StatefulWidget {

  @override
  State<open_up_profile> createState() => _MyAppState();
}

void main() {
  runApp(MaterialApp(
      home : open_up_profile(),
  ));
}

class _MyAppState extends State<open_up_profile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            openup_user_name,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => lending_page()));
          },
          child: Text(
            "Give"
          ),
        ),
        body: Column(


        children:
            [

              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('transactions').where('sender_email', isEqualTo: user_email).where('reciever_email', isEqualTo: openup_user_email)
                    .get(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
                  double sumTotal = 0.0;

                  if (querySnapshot.hasError) {
                    return Text("Something went Wrong");
                  }

                  if (!querySnapshot.hasData ) {
                    return CircularProgressIndicator();
                  }

                  if (querySnapshot.connectionState == ConnectionState.done) {
                    querySnapshot.data!.docs.forEach((doc) {
                      sumTotal = sumTotal + doc['amount'] ;
                    });
                    String keyword = sumTotal > 0 ? "To recieve" : "To give";
                    sumTotal = sumTotal >= 0 ? sumTotal : -sumTotal ;
                    return Text(keyword + " " + sumTotal.toString());
                  }

                  return Text("loading");
                },
              ),
              Container(
            height: 550,
              child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("transactions").where('sender_email', isEqualTo: user_email).where('reciever_email', isEqualTo: openup_user_email).snapshots(),
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
                int transac = data['amount'];
                String reciever = data['reciever_username'];
                String keyword = data['amount'] > 0? "given:" : "recieved:" ;
                transac = transac > 0 ? transac : -transac;
                String transacu = transac.toString();

                return ListTile(
                  title : Text(
                    "amount " + keyword + transacu,
                  ),
                  subtitle: Text(data['time'].toDate().toString()),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onTap: (){
                  },
                );
              }).toList(),
            );
          },
        ),

            )
          ]
          )
    )
    );
  }
}
