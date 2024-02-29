import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/theme.dart';
import 'package:flutter_chat_app/pages/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MaterialTheme materialTheme = MaterialTheme(ThemeData.light().textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatLaju',
      theme:
        materialTheme.light(),
        darkTheme: materialTheme.dark(),
        themeMode: ThemeMode.system,
        highContrastTheme: materialTheme.lightHighContrast(),
        highContrastDarkTheme: materialTheme.darkHighContrast(),
      home: LoginPage(),
    );
  }
}
