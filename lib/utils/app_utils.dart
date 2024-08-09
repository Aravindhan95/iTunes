
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itunes/utils/string_utils.dart';
import 'package:lottie/lottie.dart';
import 'package:root_check/root_check.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  /*Color*/
  //App PrimaryColor
  static const primaryColor = Color(0xFFFFD700);
  static const blackColor = Color(0xFF000000);
  static const whiteColor = Color(0xffffffff);

  //CircularTimer
  static const circularBgColor = Color(0xFFEBEBEB);

  //HintColor
  static const fontHintColor = Color(0xFFBCBCBC);

  //HintColor
  static const authTextColor = Color(0xFF878787);

  /*IconSize*/
  //Back icon
  static const backIconSize = 32.0;

  /*FontSize*/
  static const fontSize = 24.0;
  static const fontHintSize = 14.0;
  static const fontSize16 = 16.0;

  /*FontFamily*/
  static const fontFamily = "Poppins";

  static const int timerCount = 30;

  /*Lottie*/
  static const stopAnimation = "assets/lottie/stop.json";

  static const successSnackBar = 0;
  static const failureSnackBar = 1;
  static const warningSnackBar = 2;

  static Color getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  static TextStyle fontStyle(
      double textFontSize, Color colorName, FontWeight textFontWeight) {
    return GoogleFonts.ubuntu(
      textStyle: TextStyle(
          color: colorName,
          letterSpacing: .5,
          fontSize: textFontSize,
          fontWeight: textFontWeight),
    );
  }

  static SystemUiOverlayStyle statusBar() {
    return const SystemUiOverlayStyle(
      statusBarColor: AppUtils.primaryColor,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    );
  }

  static navigateRequiresPreviousPage(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  static closeCurrentScreen(BuildContext context) {
    Navigator.of(context).pop(true);
  }

  static navigateClearPreviousPage(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  static showLoader(BuildContext context) {
    showDialog(
      builder: (context) => Center(
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
                  style:
                      AppUtils.fontStyle(16.0, Colors.white, FontWeight.normal),
                )
              ],
            ),
          ),
        ),
      ),
      context: context,
    );
  }

  static showRootedAlert(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(StringUtils.rootedDevice, style:
              AppUtils.fontStyle(16.0, Colors.black54, FontWeight.bold),textAlign: TextAlign.center,),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Lottie.asset(AppUtils.stopAnimation),
              const SizedBox(height: 16), // Adjust spacing as needed
              Text(StringUtils.rootedDeviceContent, style:
              AppUtils.fontStyle(16.0, Colors.black54, FontWeight.bold),),
            ],
          ),
          actions: <Widget>[
            GestureDetector(
              child: Text(StringUtils.exit, style:
              AppUtils.fontStyle(16.0, Colors.black54, FontWeight.bold),),
              onTap: (){
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            )
          ],
        );
      },
    );
  }

  static dismissLoader(BuildContext context) {
    Navigator.pop(context);
  }

  static showSnackBar(BuildContext context, String message){
    var snackDemo = SnackBar(
      content: Text(message, style:
      AppUtils.fontStyle(16.0, Colors.white, FontWeight.normal),),
      backgroundColor: Colors.grey[600],
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      margin: const EdgeInsets.all(5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackDemo);
  }

  static Future<bool> internetConnection() async {

    bool connectionResult = false;

    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      connectionResult = true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      connectionResult = true;
    }
    return connectionResult;

  }

  static Future<void> callExternalBrowser(String webUrl) async {
    final Uri _url = Uri.parse(webUrl);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  static Future<bool?> checkRoot() async {
    bool? isRooted = await RootCheck.isRooted;
    return isRooted;
  }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll("-", ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}


