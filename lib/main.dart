

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import  'package:firebase_core/firebase_core.dart';
import 'package:swc_task/all_customers.dart';
import 'home_page.dart';
import 'User.dart';


final auth = FirebaseAuth.instance;

String user_email = "";
String user_username = "";


bool is_visible = true;

final db = FirebaseFirestore.instance;


Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}






class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 150,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: const Text('Log in'),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(320, 0),
                  padding: const EdgeInsets.all(10)),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInPage()));
              },
              child: const Text('Sign up'),
              style: OutlinedButton.styleFrom(
                  primary: Colors.blueAccent,
                  minimumSize: const Size(320, 0),
                  padding: const EdgeInsets.all(10),
                  side: const BorderSide(
                    color: Colors.blueAccent,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = new TextEditingController();
  TextEditingController password  = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            alignment: AlignmentDirectional.centerStart,
            child: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                size: 50,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
            height: 100,
          ),
          Container(
              alignment: AlignmentDirectional.center,
              height: 200,
              child: FlutterLogo(
                size: 150,
              )),
          Container(
            width: 350,
            height: 60,
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: email,
              obscureText: false,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          Container(
            width: 350,
            height: 60,
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              controller: password,
              keyboardType: TextInputType.text,
              obscureText: is_visible,
              decoration: InputDecoration(
                suffix: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: (){
                    setState(()
                    {
                      is_visible = is_visible ? false : true ;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await sign_in(email.text, password.text);
              user_email = email.text;
              final docRef = db.collection("users").doc(user_email);
              docRef.get().then(
                    (DocumentSnapshot doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  user_username = data['username'];
                },
                onError: (e) => print("Error getting document: $e"),
              );
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Login Success")));
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home_page() ));
            },
            child:const Text('Log in'),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(340, 50),
                padding: const EdgeInsets.all(10)),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: const Text('Or'),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                TextButton(
                  child: const Text('Sign Up'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignInPage()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController user_name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _validate = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            alignment: AlignmentDirectional.centerStart,
            child: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                size: 50,
              ),
              onPressed: (){Navigator.of(context).pop();},
            ),
          ),
          Container(
              alignment: AlignmentDirectional.center,
              height: 200,
              child: FlutterLogo(size: 150,)
          ),
          Container(
            width: 350,
            height: 60,
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              controller: email,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          Container(
            width: 350,
            height: 60,
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.text,
              obscureText: is_visible,
              controller: password,

              decoration: InputDecoration(
                suffix: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: (){
                    setState(()
                        {
                          is_visible = is_visible ? false : true ;
                        });
                  },
                ),

                hintText: "Should be more than 6 characaters",
                border: const OutlineInputBorder(),
                labelText: 'Password',
              ),

            ),
          ),
          Container(
            width: 350,
            height: 60,
            padding: const EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.text,
              obscureText: false,
              controller: user_name,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              (password.text.length <=6)? _validate = true : _validate = false;
              final user = <String, dynamic>{
                "username": user_name.text,
                "email": email.text,
              };

              await sign_up(email.text, password.text);
              db.collection("users").doc(email.text).set(user);
              user_email = email.text;
              final docRef = db.collection("users").doc(user_email);
              docRef.get().then(
                      (DocumentSnapshot doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    user_username = data['username'];
                  });
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home_page()));
            },
            child: const Text('Sign up'),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(340,50),
                padding: const EdgeInsets.all(10)
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: const Text('Or'),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Have an account?'),
                TextButton(
                  child: const Text('Log in'),
                  onPressed: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future <void> sign_in (String em, String pwd) async{
  await auth.signInWithEmailAndPassword(email: em, password: pwd);
  
}

Future <void> sign_up (String em, String pwd) async{
  await auth.createUserWithEmailAndPassword(email: em, password: pwd).then((uid) => "SIGN IN SUCCESS");
}


