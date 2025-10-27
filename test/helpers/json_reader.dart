import 'dart:io';

String readJson(String name) {
  return File('test/$name').readAsStringSync();
}
