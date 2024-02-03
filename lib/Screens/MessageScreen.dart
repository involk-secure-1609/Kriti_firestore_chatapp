import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/message.dart';
import '../providers/database_provider.dart';

class MessageScreen extends StatefulWidget {
  final String groupId;
  final String user;

  MessageScreen({required this.groupId, required this.user});

  @override
  _MessageScreen createState() => _MessageScreen();
}

class _MessageScreen extends State<MessageScreen> {

  late final Stream<QuerySnapshot> _messageStream;
  late final String oppUser;

  @override
  void initState() {
    super.initState();
    oppUser=widget.user;
    _messageStream = FirebaseFirestore.instance
        .collection('DmConversations')
        .doc(widget.groupId)
        .collection('messages')
        .orderBy('timeSent', descending: false)
        .snapshots();
  }

  DatabaseProvider databaseProvider = DatabaseProvider();
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(233, 161, 93, 1),
        title: Row(
          children: [
            CircleAvatar(
              child: Icon(Icons.person), // You can use any icon you prefer
            ),
            SizedBox(width: 10,),
            Text(oppUser),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _messageStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  return ListView(
                    reverse: false,
                    shrinkWrap: true,
                    controller: scrollController, // Add this line
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      bool isCurrentUser = data['senderId'] == "user1";
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Material(
                          color: isCurrentUser ? Color.fromRGBO(217, 217, 217, 1) : Color.fromRGBO(217, 217, 217, 1),
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: isCurrentUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['message'],
                                  style: TextStyle(
                                      color: isCurrentUser
                                          ? Colors.black
                                          : Colors.black),
                                ),
                                // SizedBox(height: 4.0),
                                // Text(
                                //   data['senderId'],
                                //   style: TextStyle(
                                //       color: isCurrentUser
                                //           ? Colors.white
                                //           : Colors.black),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Material(
                    child: TextField(
                      controller: textController,
                      autofocus: true,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      // Handle the picked image, you can send it or perform other actions
                      print("Image path: ${pickedFile.path}");
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 161, 93, 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.attachment_sharp,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () async {
                    String groupId = 'WfLIknbLhSD0yGhD69tG';
                    bool isGroup = false;
                    Message message = Message(
                        message: textController.text,
                        timeSent: DateTime.timestamp(),
                        senderId: "user1");
                    textController.clear();
                    await databaseProvider.sendMessage(
                        groupId, isGroup, message);
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 100),
                    );
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 161, 93, 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                // Container(
                //   child: FloatingActionButton(
                //     onPressed: () async {
                //       String groupId = 'WfLIknbLhSD0yGhD69tG';
                //       bool isGroup = false;
                //       Message message = Message(
                //           message: textController.text,
                //           timeSent: DateTime.timestamp(),
                //           senderId: "user1");
                //       textController.clear();
                //       await databaseProvider.sendMessage(
                //           groupId, isGroup, message);
                //       scrollController.animateTo(
                //         scrollController.position.maxScrollExtent,
                //         curve: Curves.easeOut,
                //         duration: const Duration(milliseconds: 100),
                //       );
                //
                //     },
                //     child: Icon(
                //       Icons.send,
                //       color: Colors.white,
                //       size: 20,
                //     ),
                //     backgroundColor: Color.fromRGBO(233, 161, 93, 1),
                //     elevation: 0,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
