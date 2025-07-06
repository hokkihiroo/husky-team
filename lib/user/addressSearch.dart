import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AddressSearchPage extends StatefulWidget {
  final void Function(String) onAddressSelected;
  const AddressSearchPage({required this.onAddressSelected});

  @override
  _AddressSearchPageState createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  late InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('주소 검색')),
      body: InAppWebView(
        initialFile: "asset/address_search.html",
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          javaScriptCanOpenWindowsAutomatically: true, // 팝업 허용
          supportMultipleWindows: true,                 // 다중 윈도우 지원
        ),
        onWebViewCreated: (controller) {
          webView = controller;
          controller.addJavaScriptHandler(
            handlerName: 'onAddressSelected',
            callback: (args) {
              String address = args.first;
              widget.onAddressSelected(address);
              Navigator.pop(context);
            },
          );
        },
        onCreateWindow: (controller, createWindowRequest) async {
          // 팝업이 새 창으로 열릴 때 여기를 통해 처리 가능
          // 예: 팝업 URL을 같은 WebView에 로드하거나 새 WebView를 띄울 수 있음
          // 간단히 팝업 허용만 하고 닫을 경우 true 반환
          return true;
        },
      ),

    );
  }
}
