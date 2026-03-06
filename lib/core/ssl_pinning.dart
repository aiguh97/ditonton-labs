import 'dart:io';
import 'package:flutter/services.dart';

class MyHttpOverrides extends HttpOverrides {
  final SecurityContext securityContext;

  MyHttpOverrides(this.securityContext);

  static Future<void> initialize() async {
    try {
      final certData = await rootBundle.load('assets/certs/cert.pem');
      final bytes = certData.buffer.asUint8List();

      final context = SecurityContext(withTrustedRoots: true);
      context.setTrustedCertificatesBytes(bytes);

      HttpOverrides.global = MyHttpOverrides(context);
    } catch (e) {
      // Fail silently for development
      print('SSL Pinning not initialized: $e');
    }
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return HttpClient(context: securityContext);
  }
}
