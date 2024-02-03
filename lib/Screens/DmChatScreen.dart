import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kriiti/Screens/Splash.dart';

import 'DmMessageScreen.dart';

class DmChatScreen extends StatefulWidget {
  @override
  _DmChatScreen createState() => _DmChatScreen();
}

class _DmChatScreen extends State<DmChatScreen> {
  final Stream<QuerySnapshot> _chatStream =
      FirebaseFirestore.instance.collection('DmConversations').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(233, 161, 93, 1),
        title: Text('My Chats'),
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
              if (data['user1'] == userId || data['user2'] == userId)
              {
                isContain = true;
              }
              return isContain;
            })
                .map((DocumentSnapshot document)
            {
              String GroupId =document.id;
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              if (data['user1'] == "user1") {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DmMessageScreen(groupId: GroupId,user: data['user2'],),
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
                          child: Icon(Icons.person), // You can use any icon you prefer
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          children: [
                            Text(
                                data['user2'],
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
              }
              else
              {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DmMessageScreen(groupId: GroupId,user: data['user1'],),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.person), // You can use any icon you prefer
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          children: [
                            Text(data['user2']),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            }).toList(),
          );
        },
      ),
    );
  }
}
