# 响应式设计系统

项目使用 `SizeFit` 工具进行响应式尺寸调整，基于标准 750px 设计宽度。这在不同设备尺寸上按比例缩放所有尺寸。

## 使用 rpx 单位

`num` 上的 `rpx` 扩展允许直接进行响应式尺寸调整：

- `20.rpx` 将设计尺寸转换为逻辑像素
- 示例：`width: 300.rpx` 或 `padding: EdgeInsets.all(10.rpx)`

## 工作原理

- `SizeFit.rpx` = 屏幕宽度 / 750（缩放因子）
- `20.rpx` 等同于 `20 * SizeFit.rpx` 逻辑像素
- 通过 `MyApp.builder` 中的 `SizeFit.initialize(context)` 自动初始化

## 代码示例

```dart
// 使用 rpx 进行响应式尺寸调整
Container(
  width: 300.rpx,
  height: 200.rpx,
  padding: EdgeInsets.all(10.rpx),
)
```
