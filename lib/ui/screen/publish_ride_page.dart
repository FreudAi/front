import 'package:flutter/material.dart';

class PublishRidePage extends StatefulWidget {
  const PublishRidePage({super.key});

  @override
  State<PublishRidePage> createState() => _PublishRidePageState();
}

class _PublishRidePageState extends State<PublishRidePage> {
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            title: const Text("Publish Ride"),
            backgroundColor: const Color(0xFF1D4ED8),
            foregroundColor: const Color(0xFFFFFFFF)),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Publish Ride Page',
              ),
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
