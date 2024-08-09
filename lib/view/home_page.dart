import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes/utils/AppUrl.dart';
import 'package:itunes/utils/IconWithText.dart';
import 'package:itunes/utils/app_utils.dart';
import 'package:itunes/utils/string_utils.dart';
import 'package:itunes/view/search_result.dart';
import 'package:page_transition/page_transition.dart';


class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final searchController = TextEditingController();

  List<String> reportList = [
    StringUtils.album,
    StringUtils.movie,
    StringUtils.musicVideo,
    StringUtils.musicTrack,
    StringUtils.podcast,
    StringUtils.song,
    StringUtils.audiobook,
    StringUtils.shortFilm,
    StringUtils.tvEpisode,
    StringUtils.tvSeason,
  ];

  List<String> selectedReportList = [];

  @override
  void initState() {
    super.initState();
    AppUtils.checkRoot().then((onValue) {
      setState(() {
        if (onValue != null) {
          if (onValue) {
            AppUtils.showRootedAlert(context);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils.blackColor,
      body: Padding(
        padding: EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconWithText(icon: Icons.apple, text: StringUtils.iTunes),
                const SizedBox(height: 45.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    StringUtils.searchContent,
                    textAlign: TextAlign.start,
                    style: AppUtils.fontStyle(
                      16.0,
                      AppUtils.whiteColor,
                      FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.0),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.transparent,
                            width:
                                2.0), // Color and width of the border when focused
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.transparent,
                            width:
                                1.0), // Color and width of the border when not focused
                      ),
                      hintText: StringUtils.searchHere,
                      hintStyle: AppUtils.fontStyle(
                        16.0,
                        Colors.grey,
                        FontWeight.bold,
                      ),
                      fillColor: AppUtils.getColorFromHex("#404142"),
                      filled: true,
                    ),
                    style: AppUtils.fontStyle(
                      16.0,
                      AppUtils.whiteColor,
                      FontWeight.bold,
                    ),
                    controller: searchController,
                    onChanged: (text) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    StringUtils.specifyContent,
                    textAlign: TextAlign.start,
                    style: AppUtils.fontStyle(
                      15.0,
                      AppUtils.whiteColor,
                      FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MultiSelectChip(
                    reportList,
                    onSelectionChanged: (selectedList) {
                      setState(() {
                        selectedReportList = selectedList;
                      });
                    },
                    maxSelection: reportList.length,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 46.0,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.grey[600]),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        elevation: WidgetStateProperty.all(8),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(2.0), // Rounded corners
                          ),
                        ),
                      ),
                      onPressed: () {
                        String searchStr = searchController.text;
                        AppUtils.internetConnection().then((onValue) {
                          if (onValue) {
                            if (searchStr.isEmpty) {
                              AppUtils.showSnackBar(
                                  context, StringUtils.searchEmpty);
                            } else {
                              var selectedItems = selectedReportList
                                  .map((c) => c)
                                  .toList()
                                  .join(',');

                              searchStr =
                                  "${searchStr.trim()}&entity=$selectedItems";

                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: SearchResult(searchStr)));
                            }
                          } else {
                            AppUtils.showSnackBar(
                                context, StringUtils.noInternetConnection);
                          }
                        });
                      },
                      child: Text(
                        StringUtils.submit,
                        style: AppUtils.fontStyle(
                          15.0,
                          AppUtils.whiteColor,
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>)? onSelectionChanged;
  final Function(List<String>)? onMaxSelected;
  final int? maxSelection;

  MultiSelectChip(this.reportList,
      {this.onSelectionChanged, this.onMaxSelected, this.maxSelection});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];

    for (var item in widget.reportList) {
      choices.add(
        Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
            backgroundColor: Colors.grey[600],
            selectedColor: Colors.grey[300],
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14))),
            label: Text(
              item,
              style: AppUtils.fontStyle(
                14.0,
                selectedChoices.contains(item)
                    ? AppUtils.blackColor
                    : AppUtils.whiteColor,
                FontWeight.bold,
              ),
            ),
            selected: selectedChoices.contains(item),
            onSelected: (selected) {
              if (selectedChoices.length == (widget.maxSelection ?? -1) &&
                  !selectedChoices.contains(item)) {
                widget.onMaxSelected?.call(selectedChoices);
              } else {
                setState(() {
                  selectedChoices.contains(item)
                      ? selectedChoices.remove(item)
                      : selectedChoices.add(item);
                  widget.onSelectionChanged?.call(selectedChoices);
                });
              }
            },
          ),
        ),
      );
    }

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
