import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class PinningHttpClient extends http.BaseClient {
  final HttpClient _inner;

  PinningHttpClient._(this._inner);

  static Future<PinningHttpClient> create() async {
    final context = SecurityContext(withTrustedRoots: false);

    try {
      final certBytes = await rootBundle.load('assets/certification/itunes.pem');
      context.setTrustedCertificatesBytes(certBytes.buffer.asUint8List());
    } catch (e) {
      throw Exception('Failed to load certificate: $e');
    }

    final httpClient = HttpClient(context: context);
    return PinningHttpClient._(httpClient);
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final httpRequest = await _inner.openUrl(request.method, request.url);
    request.headers.forEach(httpRequest.headers.set);
    httpRequest.followRedirects = false;

    final httpResponse = await httpRequest.close();
    return http.StreamedResponse(httpResponse, httpResponse.statusCode);
  }
}