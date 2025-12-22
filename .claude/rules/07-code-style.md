# 代码风格和 Lint 规则

## 强制执行的 Lint 规则

代码检查在 `analysis_options.yaml` 中配置，强制执行以下规则：

- `prefer_const_constructors` - 优先使用 const 构造函数
- `prefer_final_fields` - 对字段优先使用 final
- `prefer_final_locals` - 对局部变量优先使用 final
- `prefer_single_quotes` - 优先使用单引号
- `require_trailing_commas` - 要求尾部逗号（用于多行代码）

## Material 交互模式

使用 `Material` 小部件作为 `InkWell` 的父容器，以启用彩色背景上的正确墨水飞溅效果：

```dart
Material(
  color: Colors.white,
  borderRadius: BorderRadius.circular(6),
  child: InkWell(
    onTap: () { /* ... */ },
    splashColor: Colors.grey.withValues(alpha: 0.1),
    child: Padding(...),
  ),
)
```

**注意**：没有 `Material` 作为父容器，`InkWell` 的墨水效果在不透明背景上将不可见。
