import 'package:flutter/material.dart';
import 'package:itunes/utils/app_utils.dart';
import 'package:itunes/utils/string_utils.dart';
import 'package:itunes/view/grid_layout.dart';
import 'package:itunes/view/list_layout.dart';
import 'package:itunes/viewmodel/search_result_view_model.dart';
import 'package:provider/provider.dart';

class SearchResult extends StatefulWidget {

  String searchStr;

  SearchResult(this.searchStr);

  @override
  _SearchResultState createState() => _SearchResultState(this.searchStr);
}

class _SearchResultState extends State<SearchResult> {

  String searchStr;

  _SearchResultState(this.searchStr);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchResultViewModel(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppUtils.blackColor,
            title: Text(
              StringUtils.appName,
              style: AppUtils.fontStyle(
                18.0,
                AppUtils.whiteColor,
                FontWeight.normal,
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppUtils.whiteColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(AppBar().preferredSize.height),
              child: Container(
                height: 55,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      3,
                    ),
                    color: Colors.grey[600],
                  ),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white,
                    labelStyle: AppUtils.fontStyle(
                      15.0,
                      AppUtils.whiteColor,
                      FontWeight.normal,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    tabs: const [
                      Tab(
                        text: StringUtils.gridLayout,
                      ),
                      Tab(
                        text: StringUtils.listLayout,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [GridLayout(searchStr), ListLayout(searchStr)],
          ),
        ),
      ),
    );
  }
}
