# 应用架构

这是一个采用底部导航标签栏布局的 Flutter 应用。

## 整体结构

应用以 `MyHomePage`（位于 `main.dart`）作为根容器，管理标签页状态并在不同屏幕小部件之间切换。每个屏幕都是完整的 `Scaffold`，拥有自己的 `AppBar`、主体内容和 `BottomNavigationBar`。

## 项目结构

- `lib/main.dart` - 应用入口；包含 `MyApp`、`MyHomePage` 和 `MyHomePageState`（管理标签页切换）
- `lib/config/routes.dart` - 集中式路由定义（`AppRoutes` 类）
- `lib/pages/home/` - 底部导航标签屏幕（HomeScreen、MessageScreen、MineScreen）
- `lib/pages/` - 通过命名路由访问的嵌套页面（DetailPage、EditPasswordPage）
- `lib/widgets/` - 可复用组件（`BottomNav`、`SvgIcon`）
- `lib/utils/tools.dart` - 共享工具函数（`showConfirm`、`showToast`、`formatDate`、`isValidEmail`、`debounce`）
- `lib/utils/size_fit.dart` - 响应式设计系统工具
- `assets/` - 静态资源（在 `pubspec.yaml` 中引用）

## 标签页导航模式

主应用使用由 `MyHomePageState` 管理的标签页布局：
- `_selectedIndex` 跟踪当前活跃标签页（0=首页，1=消息，2=我的）
- `_screens` 列表包含三个屏幕小部件
- `onItemTapped(int index)` 更新状态并触发重新构建选定的屏幕

每个屏幕小部件（HomeScreen、MessageScreen、MineScreen）导入 `BottomNav` 并传递自己的 `currentIndex`。`BottomNav` 小部件处理导航栏 UI 并通过 `context.findAncestorStateOfType<MyHomePageState>()` 调用 `MyHomePageState.onItemTapped()`。
