import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _channel = const MethodChannel("com.mywatch.appleTest");
  Map<dynamic, dynamic> _title = {
    "x": "-",
    "y": "-",
    "z": "-",
  };

  @override
  void initState() {
    super.initState();
    _getWatchData();
  }

  void _getWatchData(){
    _channel.setMethodCallHandler((call) async {
      final methodName = call.method;
      final args = call.arguments;

      if (methodName != "updateTextFromWatch") {
        return;
      }
      setState(() {
        try{
          _title = args["text"] ;
        } catch(e){
          log(e.toString());
          _title = {
            "x":"-",
            "y":"-",
            "z":"-",
          };
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "X: ${_title?["x"] ?? "-"}",
            ),
            const SizedBox(height: 20.0),
            Text(
              "Y: ${_title?["y"] ?? "-"}",
            ),
            const SizedBox(height: 20.0),
            Text(
              "Z: ${_title?["y"] ?? "-"}",
            ),
          ],
        ),
      ),
    );
  }
}
