import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:itunes/api/BaseApiServices.dart';
import 'package:itunes/api/exceptions/AppExceptions.dart';
import 'package:itunes/api/sslpinning/PinningHttpClient.dart';

class NetworkApiService extends BaseApiServices {

  NetworkApiService();

  @override
  Future getApiResponse(String url) async {
    dynamic responseJson;

    final client = await PinningHttpClient.create();

    try {
      final response = await client.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException(message: "No Internet Connection");
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(message: response.body.toString());
      case 401:
        throw UnAuthorizedException(message: response.body.toString());
      default:
        throw FetchDataException(
            message: "Error occured while communicating with server" +
                "with ctatus code" +
                response.statusCode.toString());
    }
  }
}