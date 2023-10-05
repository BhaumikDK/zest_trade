import 'dart:async';
import 'dart:developer' as dev;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zest_trade/screens/home_screen.dart';
import 'package:zest_trade/screens/login_view.dart';
import 'package:zest_trade/screens/temp.dart';
import 'package:zest_trade/theme/light_theme.dart';
import 'package:zest_trade/utils/app_constant.dart';

void main() {
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (dynamic error, dynamic stack) {
    dev.log("Something went wrong!", error: error, stackTrace: stack);
  });
  // runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';
  var checkLogin = false;
  @override
  void initState() {
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      print('source $_source');
      // 1.
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
              _source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
          break;
        case ConnectivityResult.wifi:
          string =
              _source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
      }
      // 2.
      setState(() {});
      // 3.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            string,
            style: const TextStyle(fontSize: 30),
          ),
        ),
      );
    });
    fetchPreferences();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _networkConnectivity.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: BaseStrings.appName,
      theme: ThemeProvider.light,
      debugShowCheckedModeBanner: false,
      home: checkLogin ? const HomeView() : const LoginView(),
    );
  }

  Future fetchPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var _loginActive = prefs.getBool(SharedPrefConst.LOGIN_ACTIVE);
    setState(() {
      if (_loginActive ?? false) {
        checkLogin = true;
      } else {
        checkLogin = false;
      }
    });
  }
}
