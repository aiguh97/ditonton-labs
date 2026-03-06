import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class SSLPinning {
  static Future<IOClient> createPinnedClient() async {
    final certData = await rootBundle.load('assets/certs/cert.pem');
    final bytes = certData.buffer.asUint8List();

    final securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(bytes);

    final httpClient = HttpClient(context: securityContext);

    return IOClient(httpClient);
  }
}
