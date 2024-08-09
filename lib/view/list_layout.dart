import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itunes/api/response/Status.dart';
import 'package:itunes/model/search_response.dart';
import 'package:itunes/utils/app_utils.dart';
import 'package:itunes/utils/string_utils.dart';
import 'package:itunes/view/details_page.dart';
import 'package:itunes/viewmodel/search_result_view_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ListLayout extends StatefulWidget {
  String searchStr;

  ListLayout(this.searchStr);

  @override
  _ListLayoutState createState() => _ListLayoutState(this.searchStr);
}

class _ListLayoutState extends State<ListLayout>
    with AutomaticKeepAliveClientMixin {
  String searchStr;

  _ListLayoutState(this.searchStr);

  @override
  bool get wantKeepAlive => true;

  final SearchResultViewModel searchResultViewModel = SearchResultViewModel();

  @override
  void initState() {
    super.initState();
    final viewModel =
        Provider.of<SearchResultViewModel>(context, listen: false);

    if (viewModel.listResponse.data == null ||
        viewModel.listResponse.data!.results!.isEmpty) {
      searchResultViewModel.fetchResourcesListApi(searchStr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils.blackColor,
      body: ChangeNotifierProvider<SearchResultViewModel>(
        create: (BuildContext context) => searchResultViewModel,
        child: Consumer<SearchResultViewModel>(
          builder: (context, value, _) {
            switch (value.listResponse.status) {
              case Status.loading:
                return Center(
                  child: Container(
                    height: 45.0,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CupertinoActivityIndicator(
                            color: AppUtils.whiteColor,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            StringUtils.loading,
                            style: AppUtils.fontStyle(
                                16.0, Colors.white, FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              case Status.error:
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        StringUtils.somethingWentWrong,
                        style: AppUtils.fontStyle(
                            16.0, AppUtils.whiteColor, FontWeight.bold),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          textAlign: TextAlign.center,
                          "(${value.listResponse.message.toString()})",
                          style: AppUtils.fontStyle(
                              10.0, AppUtils.whiteColor, FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              case Status.completed:
                var json = jsonEncode(value.listResponse.data!.results!
                    .map((e) => e.toJson())
                    .toList());

                List<Results> response = parseItems(json.toString());
                Map<String?, List<Results>> groupedItems =
                    groupItemsByTitle(response);

                if (groupedItems.isEmpty) {
                  return Center(
                      child: Text(
                    StringUtils.noDataFound,
                    style: AppUtils.fontStyle(
                        16.0, AppUtils.whiteColor, FontWeight.bold),
                  ));
                }

                return ListView(
                  children: groupedItems.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(1.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ],
                          ),
                          child: Text(
                            "${entry.key}",
                            style: AppUtils.fontStyle(
                                22.0, AppUtils.whiteColor, FontWeight.bold),
                          ),
                        ),
                        ...entry.value.map((item) {
                          return ListTile(
                            onTap: () {
                              AppUtils.internetConnection().then((onValue) {
                                if (onValue) {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: DetailsPage(item)));
                                } else {
                                  AppUtils.showSnackBar(context,
                                      StringUtils.noInternetConnection);
                                }
                              });
                            },
                            title: ListItem(
                              imageUrl: item.artworkUrl100 == null
                                  ? item.artworkUrl60.toString()
                                  : item.artworkUrl100.toString(),
                              // Placeholder image URL
                              movieName: item.collectionName == null
                                  ? item.trackName.toString()
                                  : item.collectionName.toString(),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                );
              case null:
              // TODO: Handle this case.
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String imageUrl;
  final String movieName;

  ListItem({required this.imageUrl, required this.movieName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            width: 120.0,
            fit: BoxFit.fill,
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft, // Ensure text aligns to the top
              child: Text(
                movieName,
                style: AppUtils.fontStyle(
                    16.0, AppUtils.whiteColor, FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Results> parseItems(String jsonResponse) {
  final List<dynamic> parsed = json.decode(jsonResponse);
  return parsed
      .map<Results>((json) => Results.fromJson(json as Map<String, dynamic>))
      .toList();
}

Map<String?, List<Results>> groupItemsByTitle(List<Results> items) {
  Map<String?, List<Results>> groupedItems = {};

  for (var item in items) {
    if (!groupedItems.containsKey(item.kind)) {
      groupedItems[item.kind] = [];
    }
    groupedItems[item.kind]!.add(item);
  }

  return groupedItems;
}
