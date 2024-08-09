import 'package:itunes/api/BaseApiServices.dart';
import 'package:itunes/api/NetworkApiService.dart';
import 'package:itunes/model/search_response.dart';
import 'package:itunes/utils/AppUrl.dart';

class SearchRepo {

  BaseApiServices apiServices = NetworkApiService();

  Future<SearchResponse> homeScreenApi(String searchTxt) async {
    dynamic response = await apiServices.getApiResponse(AppUrl.search + searchTxt);
    try {
      return response = SearchResponse.fromJson(response);
    } catch (e) {
      print("Exp $e");
      throw e;
    }
  }
}
