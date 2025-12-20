import 'package:first_app/config/routes.dart';
import 'package:flutter/material.dart';

class DataListPage extends StatelessWidget {
  const DataListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景层 - 不影响交互
          Positioned.fill(
            child: Column(
              children: [
                // 上半部分 - 图片背景
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://picsum.photos/800/600'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // 下半部分 - 纯色背景
                Expanded(
                  flex: 4,
                  child: Container(color: const Color(0xFFF5F5F5)),
                ),
              ],
            ),
          ),

          // 内容层 - 可交互
          SafeArea(
            child: Column(
              children: [
                // AppBar区域
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        '数据列表',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // 中间内容区域（跨越上下两部分）
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.image,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '数据demo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '上半部分是图片背景\n下半部分是#F5F5F5纯色',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('点击测试交互'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // 底部列表示例
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          title: Text('列表项 ${index + 1}'),
                          subtitle: const Text(
                            '可以正常点击和交互',
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.detail);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
