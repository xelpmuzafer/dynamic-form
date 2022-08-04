
import 'package:flutter/material.dart';
import 'package:surveynow/chatbot.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Survey',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  dynamic data = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      }
    
  

  @override
  Widget build(BuildContext context) {
    return ChatBot();
  }
}
