import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String authorizationUrl;
  final String? reference;
  final Function(String) onSuccess;
  final Function(String) onFailed;
  final Function() onCancel;

  const PaymentWebView({
    Key? key,
    required this.authorizationUrl,
    this.reference,
    required this.onSuccess,
    required this.onFailed,
    required this.onCancel,
  }) : super(key: key);

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            _checkPaymentResult(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authorizationUrl));
  }

  void _checkPaymentResult(String url) {
    if (_isProcessing) return;

    final uri = url.toLowerCase();

    if (uri.contains("completed") ||
        uri.contains("success") ||
        uri.contains("vnp_responsecode=00")) {
      _isProcessing = true;
      _handleSuccess();
    } else if (uri.contains("failed") ||
        uri.contains("cancel") ||
        uri.contains("vnp_responsecode=24")) {
      _isProcessing = true;
      _handleFailed();
    }
  }

  void _handleSuccess() {
    // Pop WebView first, then call callback
    Navigator.of(context).pop();
    // Use Future.delayed to ensure pop completes before callback
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.onSuccess(widget.reference ?? '');
    });
  }

  void _handleFailed() {
    Navigator.of(context).pop();
    Future.delayed(const Duration(milliseconds: 100), () {
      widget.onFailed(widget.reference ?? '');
    });
  }

  void _handleCancel() {
    widget.onCancel();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(Tr.of(context)!.payment),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _handleCancel,
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
