import 'package:flutter/material.dart';
import 'package:pretty_json_view/pretty_json_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const JsonViewerDemo(),
    );
  }
}

class JsonViewerDemo extends StatefulWidget {
  const JsonViewerDemo({super.key});

  @override
  State<JsonViewerDemo> createState() => _JsonViewerDemoState();
}

class _JsonViewerDemoState extends State<JsonViewerDemo> {
  final _sampleJson = {
    "string": "Hello World",
    "number": 42,
    "boolean": true,
    "null": null,
    "array": [1, 2, 3, "four", {"five": 5}],
    "nested_object": {
      "name": "John Doe",
      "age": 30,
      "contact": {
        "email": "john@example.com",
        "phone": "+1234567890"
      },
      "addresses": [
        {
          "type": "home",
          "street": "123 Main St",
          "city": "New York",
          "country": "USA"
        },
        {
          "type": "work",
          "street": "456 Business Ave",
          "city": "Boston",
          "country": "USA"
        }
      ],
      "preferences": {
        "theme": "dark",
        "notifications": true,
        "languages": ["en", "es", "fr"]
      }
    }
  };

  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pretty JSON View Demo'),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
        ],
      ),
      body: JsonTreeView(
        jsonData: _sampleJson,
        keyStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: _isDarkMode ? Colors.blue[300] : Colors.blue[700],
        ),
        valueStyle: TextStyle(
          color: _isDarkMode ? Colors.grey[300] : Colors.black87,
        ),
        backgroundColor: _isDarkMode ? Colors.grey[900]! : Colors.white,
        enableSearch: true,
        searchHighlightColor: _isDarkMode ? Colors.amber[700]! : Colors.yellow,
        searchHintText: '搜索JSON...',
        showControls: true,
        initiallyExpanded: false,
        indentWidth: 22.0,
        nodeSpacing: 2.0,
        nodePadding: EdgeInsets.symmetric(vertical: 2.0),
      ),
    );
  }
} 