import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SSLPinning {
  static Future<http.Client> createClient() async {
    // Load certificate dari assets
    final ByteData data = await rootBundle.load('assets/certificates/cert.pem');
    final SecurityContext context = SecurityContext(withTrustedRoots: false);

    context.setTrustedCertificatesBytes(data.buffer.asUint8List());

    final HttpClient httpClient = HttpClient(context: context);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;

    return IOClient(httpClient);
  }

  static Future<bool> verifyCertificate(String url) async {
    try {
      final client = await createClient();
      final response = await client.get(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
