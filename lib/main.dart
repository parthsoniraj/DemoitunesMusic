import 'package:demo_itunes_music/modules/itunesListPage/ui/main_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Demo iTunes Music',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
      ),
      home: MainHomePage(title: 'iTunes Music'),
    );
  }
}
