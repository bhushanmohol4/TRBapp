// @dart=2.9
import 'package:flutter/material.dart';
import 'package:member_in_out/db.dart';
import 'package:flutter/widgets.dart';
import 'package:member_in_out/temp.dart';
import 'package:member_in_out/widgets.dart';
import 'package:member_in_out/qr_scanner.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    home: MyApp(),
  ));
}

var member;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRB Member In Out',
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      debugShowCheckedModeBanner: false,
      home: navigate(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final dbHelper = DatabaseHelper.instance;

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController memberName = new TextEditingController();

  @override
  void initState() {
    //navigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Red Baron'),
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: memberName,
              style: TextStyle(color: Colors.white),
              decoration: textFieldInputTextDec('Name'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: _insert,
                child: Text(
                  'Confirm',
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 60,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                ),
                child: Container(
                    alignment: Alignment.center,
                    child: Row(children: [
                      Image.asset('assets/logoBlack.png'),
                      SizedBox(width: 15),
                      Text(
                        'Team Red Baron',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ])),
              ),
            ),

            // ListTile(
            //     title: Text('Member Information'),
            //     onTap: () {
            //       getName();
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => memberInformation()));
            //     }),
            ListTile(
              title: Text('QR scan'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => qrscan()));
              },
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _insert() async {
    Map<String, dynamic> row = {DatabaseHelper.columnName: memberName.text};
    final res = await dbHelper.insert(row);
    print(res);
    if (res > 0) {
      Get.to(() => qrscan());
    } else {
      AlertDialog(title: Text("ERROR"));
    }
  }

  void getName() async {
    final membername = await dbHelper.show();
    member = membername[0]["name"];
    print(member);
  }

  void deleteValues() async {
    final deleted = await dbHelper.delete();
    print(deleted);
  }
}
