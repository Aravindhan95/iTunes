import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:itunes/api/response/ApiResponse.dart';
import 'package:itunes/model/search_response.dart';
import 'package:itunes/repo/SearchRepo.dart';

class SearchResultViewModel with ChangeNotifier {

  final myRepo = SearchRepo();

  ApiResponse<SearchResponse> listResponse = ApiResponse.loading();

  setListResponse(ApiResponse<SearchResponse> response) {
    listResponse = response;
    notifyListeners();
  }

  Future<void> fetchResourcesListApi(String searchTxt) async {
    setListResponse(ApiResponse.loading());
    myRepo.homeScreenApi(searchTxt).then((value) {
      setListResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        setListResponse(ApiResponse.error(error.toString()));
        print(error);
      }
    });
  }
}