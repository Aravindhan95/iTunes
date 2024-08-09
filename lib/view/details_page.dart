import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes/model/search_response.dart';
import 'package:itunes/utils/app_utils.dart';
import 'package:itunes/utils/audioplayer/PlayerWidget.dart';
import 'package:itunes/utils/string_utils.dart';
import 'dart:math' as math;

import 'package:video_player/video_player.dart';

class DetailsPage extends ConsumerStatefulWidget {
  Results value;

  DetailsPage(this.value);

  @override
  _DetailsPageState createState() => _DetailsPageState(this.value);
}

class _DetailsPageState extends ConsumerState<DetailsPage> {

  late VideoPlayerController _controller;
  late AudioPlayer player = AudioPlayer();

  Results detailData;

  _DetailsPageState(this.detailData);

  bool videoPlayerVisible = false;
  bool audioPlayerVisible = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
        Uri.parse(detailData.previewUrl.toString()))
      ..initialize().then((_) {
        setState(() {
          if (detailData.previewUrl.toString().endsWith("m4v")) {
            _controller.play();
          }
        });
      });

    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (detailData.previewUrl.toString().endsWith("m4a")) {
        await player.play(UrlSource(detailData.previewUrl.toString()));
      }
    });

    setState(() {
      if (detailData.previewUrl.toString().endsWith("m4v")) {
        videoPlayerVisible = true;
        audioPlayerVisible = false;
      } else if (detailData.previewUrl.toString().endsWith("m4a")) {
        videoPlayerVisible = false;
        audioPlayerVisible = true;
      } else {
        videoPlayerVisible = false;
        audioPlayerVisible = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils.blackColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppUtils.blackColor,
        title: Text(
          StringUtils.description,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 24.0),
              margin: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    detailData.artworkUrl100.toString(),
                    width: 120.0,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(
                    width: 40.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          detailData.trackName == null
                              ? detailData.collectionName.toString()
                              : detailData.trackName.toString(),
                          style: AppUtils.fontStyle(
                              16.0, AppUtils.whiteColor, FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          detailData.artistName.toString(),
                          style: AppUtils.fontStyle(
                              14.0, AppUtils.whiteColor, FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          // Ensure text aligns to the top
                          child: Text(
                            detailData.primaryGenreName.toString(),
                            style: AppUtils.fontStyle(
                                14.0, Colors.orange, FontWeight.normal),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        GestureDetector(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  StringUtils.preview,
                                  style: AppUtils.fontStyle(
                                    14.0,
                                    Colors.lightBlue,
                                    FontWeight.bold,
                                  ),
                                ),
                                Transform.rotate(
                                  angle: 130 * math.pi / 180,
                                  child: const IconButton(
                                    icon: Icon(
                                      Icons.link,
                                      size: 20.0,
                                      color: Colors.lightBlue,
                                    ),
                                    onPressed: null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            AppUtils.internetConnection().then((onValue) {
                              if(onValue){
                                String url = detailData.trackViewUrl == null
                                    ? detailData.collectionViewUrl.toString()
                                    : detailData.trackViewUrl.toString();
                                AppUtils.callExternalBrowser(url);
                              } else {
                                AppUtils.showSnackBar(
                                    context, StringUtils.noInternetConnection);
                              }
                            });
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: videoPlayerVisible,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 16.0),
                child: Text(
                  StringUtils.videoPreview,
                  style: AppUtils.fontStyle(
                    16.0,
                    AppUtils.whiteColor,
                    FontWeight.normal,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: audioPlayerVisible,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 16.0),
                child: Text(
                  StringUtils.audioPreview,
                  style: AppUtils.fontStyle(
                    16.0,
                    AppUtils.whiteColor,
                    FontWeight.normal,
                  ),
                ),
              ),
            ),
            Visibility(child: PlayerWidget(player: player), visible: audioPlayerVisible,),
            Visibility(
              visible: videoPlayerVisible,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Center(
                  child: SizedBox(
                    height: 200.0,
                    width: double.infinity,
                    child: _controller.value.isInitialized
                        ? GestureDetector(
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                            onTap: () {
                              AppUtils.internetConnection().then((onValue){
                                if(onValue){
                                  setState(() {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  });
                                } else {
                                  AppUtils.showSnackBar(
                                      context, StringUtils.noInternetConnection);
                                }
                              });
                            },
                          )
                        : Container(
                            height: 60.0,
                            alignment: Alignment.center,
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CupertinoActivityIndicator(
                                    color: AppUtils.whiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 24.0),
              child: Text(
                StringUtils.description,
                style: AppUtils.fontStyle(
                  16.0,
                  AppUtils.whiteColor,
                  FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 16.0, right: 5.0, bottom: 10.0),
              child: Text(
                detailData.longDescription ??
                    detailData.shortDescription ??
                    detailData.description ??
                    StringUtils.noDescriptionFound,
                style: AppUtils.fontStyle(
                  14.0,
                  AppUtils.whiteColor,
                  FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
