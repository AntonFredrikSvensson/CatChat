import 'package:cat_chat/const.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Chat',
      theme: ThemeData(
        primaryColor: themeColor,
      ),
      //home: LoginScreen(title:'Chat demo'),
      home: Text('Chat demo'),
      debugShowCheckedModeBanner: false,
    );
  }
}
