import 'dart:io';
import 'package:flutter/services.dart';

class MyHttpOverrides extends HttpOverrides {
  final SecurityContext _securityContext;

  MyHttpOverrides(this._securityContext);

  static Future<void> initialize() async {
    try {
      final certData = await rootBundle.load('assets/certs/cert.pem');
      final bytes = certData.buffer.asUint8List();
      final sc = SecurityContext(withTrustedRoots: true);
      sc.setTrustedCertificatesBytes(bytes);
      HttpOverrides.global = MyHttpOverrides(sc);
    } catch (e) {
      // If cert not provided, we don't set overrides. App should still run in dev.
      // Keep this silent; caller may log if desired.
    }
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(_securityContext);
  }
}
