import 'dart:math' as math;

import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // 滚动控制器
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    // 监听滚动事件
    _scrollController.addListener(_onScroll);
  }

  // 滚动回调
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

  // 计算 AppBar 的透明度 (0.0 - 1.0)
  double get _appBarOpacity {
    // 当滚动超过 200 像素时完全不透明
    const double maxScroll = 200.0;
    return math.min(_scrollOffset / maxScroll, 1.0);
  }

  // 计算 AppBar 背景颜色
  Color get _appBarColor {
    // 从透明渐变到白色
    return Color.lerp(Colors.transparent, Colors.white, _appBarOpacity)!;
  }

  // 计算文字颜色
  Color get _textColor {
    // 从白色渐变到黑色
    return Color.lerp(Colors.white, Colors.black, _appBarOpacity)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 让内容延伸到 AppBar 后面
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _appBarColor,
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
            title: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: _textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              child: const Text('滚动渐变效果'),
            ),
            iconTheme: IconThemeData(color: _textColor),
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
          // 顶部背景图片区域
          SliverToBoxAdapter(
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                // 渐变色效果方式
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [Colors.blue.shade400, Colors.purple.shade400],
                // ),
                // 图片背景方式
                image: DecorationImage(
                  image: NetworkImage('https://picsum.photos/800/600'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                  ],
                ),
              ),
            ),
          ),

          // 内容列表区域
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    if (index == 0)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          '内容区域',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
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
                          style: const TextStyle(fontWeight: FontWeight.w600),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('点击了项目 ${index + 1}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }, childCount: 20),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
      ),
    );
  }
}
