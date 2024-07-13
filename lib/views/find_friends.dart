import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FindFirendsPage extends StatefulWidget {
  const FindFirendsPage({super.key});

  @override
  State<FindFirendsPage> createState() => _FindFirendsPageState();
}

class _FindFirendsPageState extends State<FindFirendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(height: 200, "assets/lottie/call_firends.json"),
            const Text("Arkadaş aranıyor. Bu biraz vakit alabilir..")
          ],
        ),
      ),
    );
  }
}
