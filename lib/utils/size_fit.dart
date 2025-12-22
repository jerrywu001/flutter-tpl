import 'package:flutter/material.dart';

class SizeFit {
  static late double screenWidth; // 逻辑屏幕宽度
  static late double screenHeight; // 逻辑屏幕高度
  static late double rpx; // 1rpx 对应的逻辑像素值
  static late double px; // 1物理像素对应的逻辑像素值（用于处理2倍图、3倍图设计稿）

  static void initialize(BuildContext context, {double standardWidth = 750}) {
    final mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    rpx = screenWidth / standardWidth; // 核心公式
    px = rpx * 2; // 通常以750px宽度的设计稿为标准，其1px对应2rpx
  }

  static double setRpx(double size) => rpx * size;
  static double setPx(double size) => px * size;
}
