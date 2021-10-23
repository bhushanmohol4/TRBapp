import 'package:flutter/material.dart';
import 'package:member_in_out/db.dart';
import 'main.dart';

class memberInformation extends StatefulWidget {
  @override
  _memberInformationState createState() => _memberInformationState();
}

class _memberInformationState extends State<memberInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Red Baron'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              member.toString(),
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
