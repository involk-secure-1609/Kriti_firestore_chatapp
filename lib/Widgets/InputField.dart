import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildInput() {
  TextEditingController textEditingController = TextEditingController();
  return Container(
      width: double.infinity,
      height: 100.0,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            // Edit text
            Flexible(
              child: Container(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      autofocus: true,
                      maxLines: 5,
                      controller: textEditingController,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Type your message...',
                      ),
                    )),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: const Icon(Icons.send, size: 25),
                onPressed: () => {},
              ),
            ),
          ],
        ),
      ));
}
