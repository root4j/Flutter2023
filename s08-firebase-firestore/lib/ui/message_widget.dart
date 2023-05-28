import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../domain/message_controller.dart';
import '../model/message.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({Key? key}) : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  // Controladores Get
  MessageController msgCtrl = Get.find();
  // Controladores Widgets
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final String uid = "user@mail.com";

  // Metodo para iniciar la instancia de los listeners
  @override
  void initState() {
    super.initState();
    msgCtrl.start();
  }

  // Metodo para detener la instancia de los listeners
  @override
  void dispose() {
    msgCtrl.stop();
    super.dispose();
  }

  // Widget encargado de mostrar los mensajes que se encuentren
  // registrados en la base de datos
  Widget _messageCard(Message msg, int index) {
    return Card(
      margin: uid == msg.user
          ? const EdgeInsets.only(left: 50, top: 10, bottom: 10, right: 10)
          : const EdgeInsets.only(right: 50, top: 10, bottom: 10, left: 10),
      color: uid == msg.user ? Colors.blue[100] : Colors.grey[200],
      child: ListTile(
        title: Text(
          msg.mail,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(msg.text),
      ),
    );
  }

  // Widget encargado de mostrar el listado de mensajes en la}
  // base de datos
  Widget _messageList() {
    return GetX<MessageController>(
      builder: ((controller) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
        return ListView.builder(
          itemCount: msgCtrl.messages.length,
          controller: _scrollCtrl,
          itemBuilder: ((context, index) {
            var msg = msgCtrl.messages[index];
            return _messageCard(msg, index);
          }),
        );
      }),
    );
  }

  // Widget para el input de texto
  Widget _messageInput() {
    return Container(
      margin: const EdgeInsets.all(5),
      child: TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Message",
        ),
        controller: _msgCtrl,
        onSubmitted: (value) async {
          await _addMessage();
          _msgCtrl.clear();
        },
      ),
    );
  }

  // Hacer scroll de los mensajes nuevos
  _scrollToEnd() async {
    _scrollCtrl.animateTo(
      _scrollCtrl.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  // Metodo para enviar mensajes
  Future<void> _addMessage() async {
    await msgCtrl.addMessage(
        Message(_msgCtrl.text, uid, uid));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: _messageList(),
        ),
        _messageInput(),
      ],
    );
  }
}
