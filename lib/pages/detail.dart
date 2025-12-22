import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ybx_parent_client/utils/tools.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double get _appBarOpacity {
    const double maxScroll = 200.0;
    return math.min(_scrollOffset / maxScroll, 1.0);
  }

  Color get _appBarBgColor {
    return Color.lerp(Colors.transparent, Colors.white, _appBarOpacity)!;
  }

  Color get _appTextColor {
    return Color.lerp(Colors.white, Colors.black, _appBarOpacity)!;
  }

  @override
  Widget build(BuildContext context) {
    // 根据滚动位置动态计算状态栏样式
    final brightness = _appBarOpacity > 0.5
        ? Brightness.dark
        : Brightness.light;
    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness,
      statusBarBrightness: brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _appBarBgColor,
              // 当背景不透明时添加阴影
              boxShadow: _appBarOpacity > 0.3
                  ? [
                      const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              systemOverlayStyle: overlayStyle,
              title: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: _appTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                child: const Text('滚动渐变效果'),
              ),
              iconTheme: IconThemeData(color: _appTextColor),
              actions: [
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ],
            ),
          ),
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                // height: 300,
                decoration: const BoxDecoration(
                  // 渐变色效果方式
                  // gradient: LinearGradient(
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  //   colors: [Color.fromARGB(255, 84, 159, 219), Color.fromARGB(255, 138, 75, 247)],
                  // ),
                  // 图片背景方式
                  image: DecorationImage(
                    image: AssetImage('assets/home/bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Icon(
                      Icons.landscape,
                      size: 80,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '向上滚动',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '观察 AppBar 的变化',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final isLastItem = index == 19;
                return SafeArea(
                  top: false,
                  bottom: isLastItem,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              '列表项目 ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              '向上滚动页面，AppBar 会从透明变为白色背景',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                            onTap: () {
                              showToast(context, '点击了项目 ${index + 1}');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: 20),
            ),
          ],
        ),
        floatingActionButton: _scrollOffset > 200
            ? FloatingActionButton(
                onPressed: () {
                  // 滚动到顶部
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                tooltip: '回到顶部',
                child: const Icon(Icons.arrow_upward),
              )
            : null,
      ),
    );
  }
}
