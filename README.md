# Pretty JSON View

A beautiful and customizable JSON viewer for Flutter that provides tree view visualization with features like collapsible nodes, search functionality, and selectable text.
> Note: This package and its documentation were generated with the assistance of AI (Claude).

> ⚠️ Note: This package has only been tested on Windows platform.

## Screenshots

![image](https://github.com/nanjofan/pretty_json_view/blob/main/example/screenshots/project_image.png)

## Features

- 🌳 Tree view visualization of JSON data
- 🔍 Search functionality with highlighted results
- ✨ Customizable styles and themes
- 📱 Responsive and interactive UI
- 🎯 Selectable text content
- 🎨 Dark mode support
- 🔄 Expandable/collapsible nodes
- 📏 Customizable indentation and spacing

## Installation

Add this to your package's `pubspec.yaml` file:
```yaml
dependencies:
  pretty_json_view: ^0.0.1
```

## Usage

```dart
import 'package:pretty_json_view/pretty_json_view.dart';

// Basic usage
JsonTreeView(
  jsonData: yourJsonData,
)

// Advanced usage with customization
JsonTreeView(
  jsonData: yourJsonData,
  keyStyle: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.blue[700],
  ),
  valueStyle: TextStyle(
    color: Colors.black87,
  ),
  backgroundColor: Colors.white,
  enableSearch: true,
  searchHighlightColor: Colors.yellow,
  searchHintText: 'Search JSON...',
  showControls: true,
  initiallyExpanded: false,
  indentWidth: 22.0,
  nodeSpacing: 2.0,
  nodePadding: EdgeInsets.symmetric(vertical: 2.0),
)
```

## Customization

### Styling

You can customize various aspects of the JSON viewer:

- Text styles for keys and values
- Background color
- Search highlight color
- Indentation width
- Node spacing
- Node padding

### Theme Support

The widget automatically adapts to light and dark themes:
```Dart
JsonTreeView(
jsonData: yourJsonData,
keyStyle: TextStyle(
color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
),
valueStyle: TextStyle(
color: isDarkMode ? Colors.grey[300] : Colors.black87,
),
backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
searchHighlightColor: isDarkMode ? Colors.amber[700] : Colors.yellow,
)
```

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `jsonData` | `dynamic` | The JSON data to display (required) |
| `keyStyle` | `TextStyle?` | Style for JSON keys |
| `valueStyle` | `TextStyle?` | Style for JSON values |
| `backgroundColor` | `Color?` | Background color of the viewer |
| `enableSearch` | `bool` | Enable/disable search functionality |
| `searchHighlightColor` | `Color` | Color for search result highlights |
| `searchHintText` | `String` | Placeholder text for search input |
| `showControls` | `bool` | Show/hide expand/collapse controls |
| `initiallyExpanded` | `bool` | Whether to expand all nodes initially |
| `indentWidth` | `double` | Width of each indentation level |
| `nodeSpacing` | `double` | Vertical space between nodes |
| `nodePadding` | `EdgeInsets` | Padding within each node |

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
