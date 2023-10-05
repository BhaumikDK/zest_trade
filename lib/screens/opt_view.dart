import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zest_trade/screens/home_screen.dart';
import 'package:zest_trade/utils/app_constant.dart';
import 'package:zest_trade/utils/base_images.dart';
import 'package:zest_trade/utils/extensions.dart';

import '../utils/base_colors.dart';

class OTPVerificationView extends StatefulWidget {
  const OTPVerificationView({Key? key}) : super(key: key);

  @override
  State<OTPVerificationView> createState() => _OTPVerificationViewState();
}

class _OTPVerificationViewState extends State<OTPVerificationView> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          shape: OutlineInputBorder(
              borderSide: const BorderSide(
                color: BaseColors.transparent,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: 15.0.toRadius,
                bottomRight: 15.0.toRadius,
              )),
          title: const Text(BaseStrings.tradeList,
              style: TextStyle(
                color: BaseColors.WHITE,
                fontSize: 18.0,
                fontFamily: BaseFonts.popins_bold,
              )),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Phone Number Verification',
                style: TextStyle(fontSize: 18)),
            const SizedBox(
              height: 30,
            ),
            // Implement 4 input fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OtpInput(_fieldOne, true), // auto focus
                OtpInput(_fieldTwo, false),
                OtpInput(_fieldThree, false),
                OtpInput(_fieldFour, false)
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: 10.0.toAllBorderRadius,
              ),
              child: MaterialButton(
                onPressed: () {
                  if (_fieldOne.text.isEmpty ||
                      _fieldTwo.text.isEmpty ||
                      _fieldThree.text.isEmpty ||
                      _fieldFour.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Alert!").toCenter,
                        content: const Text("Please enter otp"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text("Ok",
                                style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                    );
                  } else {
                    checkLogin();
                    FocusScope.of(context).unfocus();
                  }
                },
                color: BaseColors.SKY_BLUE,
                height: 55.0,
                shape: OutlineInputBorder(
                    borderRadius: 10.0.toAllBorderRadius,
                    borderSide: const BorderSide(color: Colors.transparent)),
                child: const Text(
                  BaseStrings.txtSubmit,
                  style: TextStyle(
                      color: BaseColors.WHITE,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: BaseFonts.popins_bold),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkLogin() async {
    var deviceInfo = DeviceInfoPlugin();
    late String deviceId;
    late String type;

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor!;
      type = 'iOS';
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.id;
      type = 'android';
    } else {
      deviceId = 'null';
    }

    var _url = Uri.parse(RequestURL.BASE_URL + RequestURL.VERIFY_OTP);

    var _body = {
      'country_code': '+91',
      'mobile': '9106946953',
      'otp': '3333',
      'device_id': deviceId,
      'device_type': '$type'
    };

    try {
      var response = await http.post(
        _url,
        body: _body,
      );
      // http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var convert = json.decode(response.body);
        await prefs.setBool(SharedPrefConst.LOGIN_ACTIVE, true);
        await prefs.setString(
            SharedPrefConst.USER_TOKEN, convert['data']['token']);
        var _isLogin = prefs.getBool(SharedPrefConst.LOGIN_ACTIVE);
        navigateScreen(_isLogin ?? false);
      } else if (response.statusCode == 400) {
        print('Page not found');
      } else if (response.statusCode == 404) {
        print('Page not found');
      } else if (response.statusCode == 500) {
        print('Something went wrong');
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('[Error]::$error');
    }
  }

  Future<String> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    late String deviceId;

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor!;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.id;
    } else {
      deviceId = 'null';
    }
    return deviceId;
  }

  void navigateScreen([bool loginActive = false]) {
    if (loginActive) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const HomeView(),
        ),
        (route) => false,
      );
    }
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
