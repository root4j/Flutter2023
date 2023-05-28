import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? key;
  String text;
  String user;
  String mail;
  // Document Field [Required for Firestore]
  late DocumentReference reference;

  Message(this.text, this.user, this.mail);

  Message.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['user'] != null),
        assert(map['mail'] != null),
        assert(map['text'] != null),
        user = map['user'],
        mail = map['mail'],
        text = map['text'];

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);

  toJson() {
    return {"text": text, "user": user, "mail": mail};
  }
}