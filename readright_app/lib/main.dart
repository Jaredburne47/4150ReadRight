import 'package:flutter/material.dart';


void main() => runApp(const ReadRightApp());

class ReadRightApp extends StatelessWidget {
  const ReadRightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReadRight Prototype'
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      //this connects to a function that will be made in probably a login_screen file
      home: const LoginScreen(),
    );

  }

}