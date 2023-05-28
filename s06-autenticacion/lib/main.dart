import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'FlutterFire Auth'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String message = '';
  final String _email = 'rjay@uninorte.edu.co';
  final String _pswd = 'Sup3rS3cr3tP@ssw0rd';

  void _createUser() async {
    String msg = "";
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _pswd);
      msg = 'User created!';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        msg = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        msg = 'The account already exists for that email.';
      }
    } catch (e) {
      msg = 'error caught: $e';
    } finally {
      setState(() {
        message = msg;
      });
    }
  }

  void _verifyUser() async {
    String msg = "";
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _pswd);
      msg = 'User Authenticated!';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        msg = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        msg = 'Wrong password provided for that user.';
      }
    } catch (e) {
      msg = 'error caught: $e';
    } finally {
      setState(() {
        message = msg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _createUser();
            },
            tooltip: 'Create',
            child: const Icon(Icons.supervisor_account),
          ),
          const SizedBox(
            height: 4,
          ),
          FloatingActionButton(
            onPressed: () {
              _verifyUser();
            },
            tooltip: 'Verify',
            child: const Icon(Icons.verified_user),
          ),
        ],
      ),
    );
  }
}
