import 'package:flutter/material.dart';

import 'startup.dart';
import 'app.dart';

void main() async {
  try {
    await startup();
    runApp(const App());
  } catch (e, stack) {
    debugPrint('Error during startup: $e');
    debugPrint('Stack trace: $stack');
    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text('Startup Error: $e'))),
      ),
    );
  }
}
