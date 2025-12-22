# 可复用组件

## SvgIcon 组件

简化的 SVG 图标组件，呈现 1:1 纵横比的正方形图标：

```dart
SvgIcon(
  icon: 'assets/home/icon-user.svg',
  size: 20,
  color: Color(0xFF333333),  // 可选，默认为 Color(0xFFA28071)
)
```

### 参数说明

- `icon` - SVG 文件路径
- `size` - 图标尺寸（逻辑像素）
- `color` - 图标颜色（可选）
