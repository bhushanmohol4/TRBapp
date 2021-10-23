import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:gsheets/gsheets.dart';
import 'package:member_in_out/db.dart';
import 'package:member_in_out/main.dart' as m;
import 'package:device_info/device_info.dart';

const _credentials = r'''
{
  "type": "service_account",
  "project_id": "combustion",
  "private_key_id": "b0c26c1f0a5cbb15f2821619daffcaf763578adb",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC6Wx6vnrcyzNdU\noD/EI9FpkAB1nxc66sVP59X2HMOJ2Drdvke1iUiVEx4Sdz5B2gln8qhCnGKVPC7E\neRIwY5blLGkhFBLLCrQ99o8P1RnYVnEjJs0dY2gP+tzfLx/TxgJpon4iJfwylPCK\nUf1RyTnYarqGNGZHkWMNBF42HX5WyXNIa/CNtGpAzcYaxAXJKB7zpiQQLE//8/pt\nrKeGY4u1J3Vrm3m+zUx3l87WFpA+GrTJn3QpmgKEwNwNIaR5SImd4lLjbq8nBsQu\nKmjQ8N8wF4EvpoFIOihrZW0sT6WTIo0ngMbfjM1ZIBfHgyCvRqTgFsJzaxKEqIkh\nsBs37FdDAgMBAAECggEAPrWp8lQY9s3Kii4wtwqMjhbIqMwDz64v/o8Xx21veYPb\nb0H4NIUBeTTJMlKRDyzVbHbSGzQv0mNBo5jQP5tLrEvRBrIQDuZHt/AvvRarT0rr\nYHZOoJySaIo06B+d+LARoMVu54PbxZOsDAfCFFMAFaz4nm+kmWG5sKgvIcuz93TY\nujlJUJcfTN4EMHSfhBGDK8snPU++/Vo1wamPujUD1IvMaN1T1k/UTiBu2zDB4JwD\nZQTTIb8SfMUXoXhp57aIsLgp7XqnbNiWx726BJ00lgSqtC2Uhpsld5n2R4Hm+egW\nqWX28ERpCLRanD3SwxH1AIMMD/coktCbZ4D3AisOBQKBgQDgWID/lqiqc6CTcozq\niNz2mEsRJD2V0lcGzG+IIDecljnlqqkuCKEtAjKZNeWr0ZtPG+CwqjFNdr1ivE3w\nE49oC6DQ9ag78VBRgNS+qmPPAQhE9LqBcK59SpwAkBwGMdkOLMtOLSwxvzEH287S\nM1LJv8TNrgY58e0r9MeSGNFDRQKBgQDUpmc8JAc0toIMAJiRlQ5MmYZxB3eZ4J0w\nOc0APt0Y1AB0TG7QWbA71FFvalhn1FbocCrScT0plDtQ48Gk1FIEZyaZIb5uD8V2\nLFDhDBxkcFoysiVObsTAKL08sqxCo5kKOw0h149bKEwb/fhyQAXk6A4Qqk9BIMFc\n4kl2ok5U5wKBgQCrZxMPs3Sj3fmmDZPaMLzZbpuTuiOPTwgMeq8PysWSTjhn3w6o\nzBEQSSiNY99Yeal2NG9jqnRGodyqDgJh1R/wt0mjvLxPJ9xcmNhx386nvjsqK+w+\nru+xbApqZ6/xj64tJU4jKWIlk9SLE4YdlPbAi1J6bmX1aX/x4G+FkI55HQKBgFSu\nV1n5tuzk6PDCo/8FboZOdN057gTXD4GO4vYAEqe6dNvbPB24OZf5utw1azMdueYi\nFMts0MBoCR7zM7/h1S9vrE06xMyrdyTSDPsxiXTt0N1zV6veLHehQYqUVEjNQTpz\nvY0GfE3+xCA5iOBmYnJ/fmpgh+MVmirU6hBWHf9tAoGBAJJPSArmE2S10Kh/lly1\n8FoK7KQSwA+Fg6Wqt2BeMwTHie94Uk4u+1LY/j84R81fePKfINo36Epq/w8NN1av\nYFlcywahY5Fk8VLD9kWtjK0QXIMO8WiD3IhefUk5Nsq/eBC7ZCGepjC/6vmVDyGw\naKli9svN4t7asbu+bZLIlWZV\n-----END PRIVATE KEY-----\n",
  "client_email": "trbqr-297@combustion.iam.gserviceaccount.com",
  "client_id": "114607810556751262152",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/trbqr-297%40combustion.iam.gserviceaccount.com"
}
''';

const _spreadsheetId = '1cNtQML0SBhcbFk85Gu-73k9EdQ_NzZdM3J7arPBEFzw';

final dbHelper = DatabaseHelper.instance;
var member;
var deviceId;

class qrscan extends StatefulWidget {
  @override
  _qrscanState createState() => _qrscanState();
}

class _qrscanState extends State<qrscan> {
  String response = '';

  void inTime() async {
    final gsheets = GSheets(_credentials);
    String now = DateTime.now().toString();
    List<String> day = now.split(" ");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    deviceId = androidDeviceInfo.androidId;
    print('In');
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    var sheet = ss.worksheetByTitle(day[0]);
    TimeOfDay time = TimeOfDay.now();
    String Time = time.hour.toString() + ':' + time.minute.toString();
    final tempRow = [deviceId.toString(), member.toString(), Time];
    await sheet!.values.appendRow(tempRow);
  }

  void outTime() async {
    final gsheets = GSheets(_credentials);
    String now = DateTime.now().toString();
    List<String> day = now.split(" ");
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    var sheet = ss.worksheetByTitle(day[0]);
    TimeOfDay time = TimeOfDay.now();
    String Time = time.hour.toString() + ':' + time.minute.toString();
    int pos = await sheet!.values.rowIndexOf(deviceId);
    await sheet.values.insertValue(Time, column: 4, row: pos);
  }

  deviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo andridDeviceInfo = await deviceInfo.androidInfo;
    return andridDeviceInfo.androidId;
  }

  @override
  void initState() {
    getName();
    print(member);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello $member'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: scan,
                child: const Text(
                  'START CAMERA',
                  style: TextStyle(color: Colors.black),
                )),
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
              title: Text('Delete Data'),
              onTap: () {
                deleteValues();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => m.MyApp()));
              },
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future scan() async {
    ScanResult codeScanner = await BarcodeScanner.scan();
    String result = codeScanner.rawContent;
    getName();
    setState(() {
      response = result;
      if (response == '1') {
        inTime();
      } else if (response == '2') {
        outTime();
      }
    });
  }

  void getName() async {
    final membername = await dbHelper.show();
    member = membername[0]["name"];
    //print(member);
  }

  void deleteValues() async {
    final deleted = await dbHelper.delete();
    print(deleted);
  }
}
