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

        // 상단 공지사항 남색
        backgroundColor: const Color(0xFF17233C),

        // AppBar 그림자 제거
        elevation: 0,

        // 좌우 여백
        titleSpacing: 20,

        title: Row(
          children: [
            // 알림 아이콘
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF253452),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFFE6D19A),
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            // 제목
            Text(
              title!,
              style: const TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),

        centerTitle: false,

        // AppBar 내부 아이콘/텍스트 기본 색상
        foregroundColor: Colors.white,
      );
    }
  }
}