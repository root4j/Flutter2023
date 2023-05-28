import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Notificaciones'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Declarar clase notificadora
  late FlutterLocalNotificationsPlugin _fnp;

  // Sobreescribir un metodo de la clase State
  @override
  void initState() {
    // Invocar la funcionalidad normal
    super.initState();
    // Logica complementaria
    var ais = const AndroidInitializationSettings('face_happy');
    var iss = InitializationSettings(android: ais);
    _fnp = FlutterLocalNotificationsPlugin();
    _fnp.initialize(iss);
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
          children: const <Widget>[
            Text(
              'App Notification Sample',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNotification();
        },
        tooltip: 'Notify',
        child: const Icon(Icons.message_rounded),
      ),
    );
  }

  Future showNotification() async {
    // Crear detalles para Android
    var ands = const AndroidNotificationDetails("channel-Id-1", "channel-name",
        channelDescription: "Test Class",
        playSound: false,
        importance: Importance.high,
        priority: Priority.max);
    // Unificar configuraciones de detalle
    var nd = NotificationDetails(android: ands);
    // Mostrar la notificacion
    _fnp.show(Random().nextInt(16), "Notificacion de Ejemplo",
        "Mensaje de Ejemplo!", nd,
        payload: "Mensaje de Ejemplo!");
  }
}
