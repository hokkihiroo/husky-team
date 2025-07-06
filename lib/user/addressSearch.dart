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
      ),
    );
  }
}
