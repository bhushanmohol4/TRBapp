import 'package:flutter/material.dart';
import 'main.dart' as here;
import 'package:member_in_out/qr_scanner.dart';
import 'package:get/get.dart';

String c = '';

navigate() {
  tempo();
  print(c);
  if (c != '0') {
    return qrscan();
    //Get.to(() => qrscan());
  } else {
    return here.MyHomePage();
    //Get.to(here.MyHomePage());
  }
}

tempo() async {
  final count = await here.dbHelper.queryRowCount();
  c = count.toString();
  return c;
}
