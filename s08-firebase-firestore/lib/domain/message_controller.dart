import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../model/message.dart';

class MessageController extends GetxController {
  // Variable que maneja el listado de mensajes
  // que vienen de la base de datos firestore
  final _messages = <Message>[].obs;

  // Variables necesaria para la configuracion de
  // las bases de datos firestore
  final db = FirebaseFirestore.instance.collection('messages');
  final _events = FirebaseFirestore.instance.collection('messages').snapshots();
  late StreamSubscription<Object?> _subs;

  // Getter
  List<Message> get messages => _messages;

  // Metodo para iniciar los listeners
  start() {
    _subs = _events.listen((event) {
      _messages.clear();
      for (var item in event.docs) {
        _messages.add(Message.fromSnapshot(item));
      }
    });
  }

  // Metodo para detener los listeners
  stop() {
    _subs.cancel();
  }

  // Metodo que escucha los nuevos registros
  Future<void> addMessage(Message msg) async {
    logInfo('Data was Add...');
    try {
      db
          .add(msg.toJson())
          .then((value) => logInfo('Data was Add...'))
          .catchError((error) => logError('Error $error'));
    } catch (e) {
      return Future.error(e);
    }
  }
}