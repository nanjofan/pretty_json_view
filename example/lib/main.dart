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
  bool _isDarkMode = false;
  bool _isExpanded = true;
  final _jsonViewKey = GlobalKey<JsonTreeViewState>();  // 使用公开的 State 类型
  
  // 添加两个不同的JSON字符串
  final _sampleJson1 = '''
{
  "string": "Hello World",
  "number": 42,
  "boolean": true,
  "null": null,
  "array": [1, 2, 3, "four", {"five": 5}]
}''';

  final _sampleJson2 = '''
{
  "user": {
    "name": "John Doe",
    "age": 30,
    "email": "john@example.com",
    "isActive": true,
    "hobbies": ["reading", "gaming", "coding"]
  }
}''';

  // 当前显示的JSON字符串
  late String _currentJson;
  
  @override
  void initState() {
    super.initState();
    _currentJson = _sampleJson1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pretty JSON View Demo'),
        actions: [
          IconButton(
            icon: Icon(_isExpanded ? Icons.unfold_less : Icons.unfold_more),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
                if (_isExpanded) {
                  _jsonViewKey.expandAll();
                } else {
                  _jsonViewKey.collapseAll();
                }
              });
            },
            tooltip: _isExpanded ? '折叠所有' : '展开所有',
          ),
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
        key: _jsonViewKey,  // 使用 GlobalKey
        jsonString: _currentJson,
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
        initiallyExpanded: _isExpanded,
      ),
    );
  }
} 