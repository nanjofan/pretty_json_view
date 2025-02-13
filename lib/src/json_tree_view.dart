import 'package:flutter/material.dart';
import 'models/json_node.dart';
import 'utils/json_parser.dart';
import 'json_tree_node.dart';

class JsonTreeView extends StatefulWidget {
  /// JSON数据字符串或Map对象
  final dynamic jsonData;
  
  /// 节点展开/折叠的图标
  final Widget? expandIcon;
  final Widget? collapseIcon;
  
  /// 节点样式配置
  final TextStyle? keyStyle;
  final TextStyle? valueStyle;
  final bool initiallyExpanded;

  /// 添加新属性
  final Duration animationDuration;
  final bool showControls;

  /// 搜索相关配置
  final bool enableSearch;
  final Color searchHighlightColor;
  final String searchHintText;

  final Color? backgroundColor;

  /// 缩进设置
  final double indentWidth;      // 缩进宽度
  final double nodeSpacing;      // 节点间距
  final EdgeInsets nodePadding;  // 节点内边距

  const JsonTreeView({
    super.key,
    required this.jsonData,
    this.expandIcon,
    this.collapseIcon,
    this.keyStyle,
    this.valueStyle,
    this.initiallyExpanded = false,
    this.animationDuration = const Duration(milliseconds: 200),
    this.showControls = true,
    this.enableSearch = true,
    this.searchHighlightColor = const Color(0xFFFFEB3B),
    this.searchHintText = '搜索...',
    this.backgroundColor,
    this.indentWidth = 24.0,           // 默认缩进宽度
    this.nodeSpacing = 4.0,            // 默认节点间距
    this.nodePadding = const EdgeInsets.symmetric(vertical: 4.0),  // 默认节点内边距
  });

  @override
  State<JsonTreeView> createState() => _JsonTreeViewState();
}

class _JsonTreeViewState extends State<JsonTreeView> {
  late JsonNode _rootNode;
  final Map<String, bool> _expandedNodes = {};
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _searchMatchedNodes = {};

  @override
  void initState() {
    super.initState();
    _parseJson();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _parseJson() {
    _rootNode = JsonParser.parse(widget.jsonData);
    if (widget.initiallyExpanded) {
      _expandAll();
    }
  }

  void _expandAll() {
    setState(() {
      _expandAllNodes(_rootNode);
    });
  }

  void _toggleNode(String key) {
    setState(() {
      _expandedNodes[key] = !(_expandedNodes[key] ?? false);
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _searchMatchedNodes.clear();
      if (_searchQuery.isNotEmpty) {
        _searchNodes(_rootNode);
        // 展开包含搜索结果的节点的父节点
        _expandMatchedNodes();
      }
    });
  }

  bool _searchNodes(JsonNode node) {
    bool hasMatch = false;
    
    // 搜索当前节点
    if (_nodeMatchesSearch(node)) {
      _searchMatchedNodes.add(node.key);
      hasMatch = true;
    }

    // 递归搜索子节点
    for (var child in node.children) {
      if (_searchNodes(child)) {
        hasMatch = true;
      }
    }

    return hasMatch;
  }

  bool _nodeMatchesSearch(JsonNode node) {
    return node.key.toLowerCase().contains(_searchQuery) ||
           node.value.toString().toLowerCase().contains(_searchQuery);
  }

  void _expandMatchedNodes() {
    void expandParents(JsonNode node) {
      if (_searchMatchedNodes.contains(node.key)) {
        _expandNodeAndParents(node);
      }
      for (var child in node.children) {
        expandParents(child);
      }
    }
    expandParents(_rootNode);
  }

  void _expandNodeAndParents(JsonNode node) {
    String currentKey = node.key;
    while (currentKey.isNotEmpty) {
      _expandedNodes[currentKey] = true;
      // 获取父节点的key
      final lastDotIndex = currentKey.lastIndexOf('.');
      if (lastDotIndex == -1) break;
      currentKey = currentKey.substring(0, lastDotIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showControls) _buildControls(),
          if (widget.enableSearch) _buildSearchBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildNode(_rootNode),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: _expandAll,
            icon: const Icon(Icons.unfold_more),
            label: const Text('展开所有'),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: _collapseAll,
            icon: const Icon(Icons.unfold_less),
            label: const Text('折叠所有'),
          ),
        ],
      ),
    );
  }

  void _collapseAll() {
    setState(() {
      _expandedNodes.clear();
    });
  }

  void _expandAllNodes(JsonNode node) {
    _expandedNodes[node.key] = true;
    for (var child in node.children) {
      _expandAllNodes(child);
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: widget.searchHintText,
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _handleSearch('');
                  },
                )
              : null,
        ),
        onChanged: _handleSearch,
      ),
    );
  }

  Widget _buildNode(JsonNode node, [int depth = 0]) {
    final isExpanded = _expandedNodes[node.key] ?? false;
    final isMatched = _searchQuery.isNotEmpty && _searchMatchedNodes.contains(node.key);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JsonTreeNode(
          keyName: node.key,
          value: node.value,
          isExpanded: isExpanded,
          onTap: () => _toggleNode(node.key),
          keyStyle: widget.keyStyle,
          valueStyle: widget.valueStyle,
          expandIcon: widget.expandIcon,
          collapseIcon: widget.collapseIcon,
          depth: depth,
          type: node.type,
          animationDuration: widget.animationDuration,
          isHighlighted: isMatched,
          highlightColor: widget.searchHighlightColor,
          searchQuery: _searchQuery,
          padding: widget.nodePadding,  // 传递节点内边距
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: EdgeInsets.only(left: widget.indentWidth),  // 使用配置的缩进宽度
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: node.children.map((child) {
                return Padding(
                  padding: EdgeInsets.only(top: widget.nodeSpacing),  // 添加节点间距
                  child: _buildNode(child, depth + 1),
                );
              }).toList(),
            ),
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: widget.animationDuration,
        ),
      ],
    );
  }
} 