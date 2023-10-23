import 'package:flexible_dropdown/flexible_dropdown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SafeArea(child: SizedBox(height: 15)),
              _buildFlexibleDropdown(),
              const SafeArea(child: SizedBox(height: 15)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextBtn(String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.blueAccent.withOpacity(.2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildFlexibleDropdown() {
    return FlexibleDropdown(
      overlayChild: Container(
        height: 300,
        width: double.infinity,
        color: Colors.white,
      ),
      barrierColor: Colors.black38.withOpacity(.2),
      barrierShape: BarrierShape.headerTrans,
      textDirection: TextDirection.ltr,
      offset: Offset.zero,
      child: _buildTextBtn('Flexible Dropdown'),
    );
  }
}


