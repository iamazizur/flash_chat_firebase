// ignore_for_file: prefer_final_fields, use_key_in_widget_constructors, avoid_print, prefer_const_constructors, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  late User loggedInUser;
  String messageText = '';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   var list = [];
  //   final messages = await _firebaseFirestore.collection('messages').get();

  //   var message = messages.docs;
  //   for (var element in message) {
  //     // print(element.data());
  //     // print(element.id);
  //     list.add(element.data());
  //   }

  //   list.forEach((element) {
  //     print(element);
  //   });
  // }
  void messagesStream() async {
    await for (var snapshot
        in _firebaseFirestore.collection('messages').snapshots()) {
      var messages = snapshot.docs;
      for (var item in messages) {
        print(item.data());
      }
      print('loop ends');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                //Implement logout functionality
                // await _auth.signOut();
                // Navigator.pop(context);
                // getMessages();
                messagesStream();
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
            MessagesStream(firebaseFirestore: _firebaseFirestore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firebaseFirestore.collection('messages').add(
                          {'text': messageText, 'sender': loggedInUser.email});
                    },
                    child: Text(
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

class MessagesStream extends StatelessWidget {
  const MessagesStream({
    Key? key,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseFirestore = firebaseFirestore,
        super(key: key);

  final FirebaseFirestore _firebaseFirestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseFirestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data;
          final message = messages?.docs;
          List<MessageBubble> messageBubbles = [];

          for (var item in message!) {
            final messageText = item['text'];
            final messageSender = item['sender'];
            final messageBubble = MessageBubble(messageSender, messageText);
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            flex: 8,
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              children: messageBubbles,
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;

  const MessageBubble(this.sender, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            sender,
            style: TextStyle(color: Colors.grey),
          ),
          Material(
            borderRadius: BorderRadius.circular(30),
            elevation: 5,
            color: Colors.blueAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
