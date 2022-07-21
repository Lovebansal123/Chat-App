import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letschat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


final _firestore = FirebaseFirestore.instance;
late User loggedinuser;
class ChatScreen extends StatefulWidget {
  static const String id = 'chatscreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
 final messagetextcontroller=TextEditingController();
  final _auth = FirebaseAuth.instance;

  late String messagetext;

  @override
  void initState() {
    super.initState();

    getcurrentuser();
  }

  void getcurrentuser() async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedinuser = user;
      }
    } catch (e) {
      print(e);
    }
  }

// void getmessages() async{
//     final messages = await _firestore.collection('messages').get();
//     for(var message in messages.docs){
//       print(message.data());
//     }
// }
//   void getstream() async {
//     await for (var snapshots in _firestore.collection('messages').snapshots()) {
//       for (var message in snapshots.docs) {
//         print(message.data());
//       }
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Messagestream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messagetextcontroller,
                      onChanged: (value) {
                        messagetext = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messagetextcontroller.clear();
                      _firestore.collection('messages').add({
                        'text': messagetext,
                        'sender': loggedinuser.email,
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Messagestream extends StatelessWidget {
  const Messagestream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final messages = snapshot.data!.docs.reversed;
          List<MessageBubble> messagebubbles = [];
          for (var message in messages) {
            final messageText = message.get('text');
            final messagesender = message.get('sender');
            final currentuser = loggedinuser.email;
            final messagebubble = MessageBubble(
              text: messageText,
              sender: messagesender,
              isMe: currentuser==loggedinuser,
            );
            messagebubbles.add(messagebubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              children: messagebubbles,
            ),
          );
        });
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({required this.text, required this.sender, required this.isMe});

  final String text;
  final String sender;
 final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          Text(sender, style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),),
          Material(
            elevation: 5,
            borderRadius: isMe? BorderRadius.only(bottomRight: Radius.circular(30), topRight: Radius.circular(30), bottomLeft: Radius.circular(30)):BorderRadius.only(bottomRight: Radius.circular(30), topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
            color: isMe?Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color:isMe?Colors.white :Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      padding: EdgeInsets.all(10),
    );
  }
}
