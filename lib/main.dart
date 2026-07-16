import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

// VAVE AI 移动应用包装器
// 配置你的 VAVE 应用地址（部署后更新）
const String VAVE_APP_URL = 'https://vave-ai-4ykefkww4nqwobv2kftbxjj.streamlit.app'; // Streamlit Cloud 固定地址

void main() {
  runApp(const VaveMobileApp());
}

class VaveMobileApp extends StatelessWidget {
  const VaveMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VAVE AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B5CF6)),
        useMaterial3: true,
      ),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initWebView();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        _hasError = true;
        _errorMessage = '无网络连接，请检查网络设置';
      });
    }
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF8FAFC))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // 加载进度
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            // 注入 CSS 优化移动端显示
            _injectMobileCSS();
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
              _errorMessage = '加载失败: ${error.description}';
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // 允许所有导航
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(VAVE_APP_URL));
  }

  Future<void> _injectMobileCSS() async {
    const String css = '''
      /* 强制移动端适配 */
      .stApp { max-width: 100vw !important; }
      .main .block-container { padding: 1rem !important; }
      /* 隐藏 Streamlit 顶部 */
      header[data-testid="stHeader"] { display: none !important; }
      /* 优化按钮触摸 */
      .stButton>button { min-height: 44px !important; }
      /* 侧边栏优化 */
      section[data-testid="stSidebar"] { width: 280px !important; }
    ''';
    await _controller.runJavaScript('''
      const style = document.createElement('style');
      style.textContent = `$css`;
      document.head.appendChild(style);
    ''');
  }

  Future<void> _reload() async {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    await _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // WebView
            if (!_hasError)
              WebViewWidget(controller: _controller),

            // 加载指示器
            if (_isLoading && !_hasError)
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('正在加载 VAVE AI...', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

            // 错误页面
            if (_hasError)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _reload,
                        icon: const Icon(Icons.refresh),
                        label: const Text('重新加载'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      // 底部刷新按钮
      floatingActionButton: FloatingActionButton.small(
        onPressed: _reload,
        tooltip: '刷新',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
