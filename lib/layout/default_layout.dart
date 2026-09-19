import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;

  const DefaultLayout({
    super.key,
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // 최상단 상태바 배경
        statusBarColor: Colors.white,

        // Android 시간 / Wi-Fi / 배터리 → 검은색
        statusBarIconBrightness: Brightness.dark,

        // iOS 시간 / 상태 아이콘 → 검은색
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor ?? Colors.white,
        appBar: renderAppBar(),
        body: child,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor ?? Colors.white,
        elevation: 0,
        title: Text(
          title!,
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: false,
        foregroundColor: Colors.black,
      );
    }
  }
}