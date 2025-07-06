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
        initialFile: 'asset/address_search.html',
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            supportZoom: true,
            javaScriptEnabled: true,
          ),
          android: AndroidInAppWebViewOptions(
            supportMultipleWindows: true,
          ),
        ),
        onCreateWindow: (controller, createWindowRequest) async {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(url: createWindowRequest.request.url),
                    // 팝업 안에서 추가 팝업이 필요하면 여기서도 onCreateWindow 처리 가능
                  ),
                ),
              );
            },
          );
          return true; // 새 창 생성 완료 알림
        },

      ),
    );
  }
}
