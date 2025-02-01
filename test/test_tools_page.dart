import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

// Import your ShowToolsPage file
import '../screens/tools/tools_screen.dart';

// Mock or minimal implementations for dependencies
class DataModel extends ChangeNotifier {
  // Add minimal implementation if needed
}

void main() {
  runApp(
    MaterialApp(
      home: ShowToolsPage(),
    ),
  );
}
