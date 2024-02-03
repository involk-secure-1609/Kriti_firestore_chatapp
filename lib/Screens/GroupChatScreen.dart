import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kriiti/Screens/Splash.dart';

import 'DmMessageScreen.dart';
import 'GroupMessageScreen.dart';

class GroupChatScreen extends StatefulWidget {
  @override
  _GroupChatScreen createState() => _GroupChatScreen();
}

class _GroupChatScreen extends State<GroupChatScreen> {
  final Stream<QuerySnapshot> _chatStream =
  FirebaseFirestore.instance.collection('GroupConversations').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(233, 161, 93, 1),
          title: Text('Team Chats'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }

          return ListView(
            children: snapshot.data!.docs.where((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              var isContain = false;
              String userId = "user1";
              if (data['members'].includes(userId)) {
                isContain = true;
              }
              return isContain;
            })
                .map((DocumentSnapshot document)
            {
              String GroupId =document.id;
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupMessageScreen(groupId: GroupId,team: data['chatName'],),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(30.0),
                    padding: EdgeInsets.fromLTRB(5, 5, 20, 20),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(217, 217, 217,1 ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          child: Icon(Icons.group_sharp), // You can use any icon you prefer
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          children: [
                            Text(
                              data['chatName'],
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
            }).toList(),
          );
        },
      ),
    );
  }
}
