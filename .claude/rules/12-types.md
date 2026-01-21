# 类型定义规范

## 概述

项目使用强类型定义来确保类型安全和代码可维护性。所有 API 相关的类型定义统一放在 `lib/types/` 目录下。

## 文件结构

```
lib/types/
├── home/
│   └── index.dart    # 首页相关类型定义
└── ...               # 其他模块类型定义
```

## 枚举类型

使用 enum 定义状态枚举，包含 value 字段用于序列化：

```dart
/// 陪伴官审核状态枚举
enum CompanionStatus {
  /// 待审核
  pending('PENDING'),

  /// 已通过
  approved('APPROVED'),

  /// 已驳回
  rejected('REJECTED');

  const CompanionStatus(this.value);
  final String value;
}
```

### 关键点

1. 使用三斜线注释（`///`）添加文档注释
2. 每个枚举值都添加注释说明
3. 包含 `value` 字段用于与后端交互
4. 使用 `const` 构造函数

## 数据模型类

### 基本结构

```dart
/// 陪伴官列表项
class CompanionListItem {
  CompanionListItem({
    required this.id,
    required this.userId,
    this.nickname,
    this.avatar,
    this.age,
    this.tags,
  });

  /// 陪伴官ID
  final String id;

  /// 用户ID
  final String userId;

  /// 昵称
  final String? nickname;

  /// 头像URL
  final String? avatar;

  /// 年龄
  final int? age;

  /// 技能标签
  final List<String>? tags;

  factory CompanionListItem.fromJson(Map<String, dynamic> json) {
    return CompanionListItem(
      id: json['id'] as String,
      userId: json['userId'] as String,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      age: json['age'] as int?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }
}
```

### 关键点

1. **命名构造函数参数**：使用命名参数而非位置参数
2. **必填字段**：使用 `required` 关键字
3. **可选字段**：使用 `?` 标记为可空类型
4. **字段注释**：每个字段都添加三斜线注释
5. **final 字段**：所有字段使用 `final` 确保不可变性
6. **fromJson 工厂构造函数**：用于 JSON 反序列化

### 类型转换规则

```dart
// 字符串
json['name'] as String?

// 数字
json['age'] as int?
json['price'] as double?

// 数字转 double
(json['distance'] as num?)?.toDouble()

// 列表
(json['tags'] as List<dynamic>?)?.map((e) => e as String).toList()

// 嵌套对象
(json['user'] as Map<String, dynamic>?)?.let((e) => User.fromJson(e))

// 嵌套对象列表
(json['list'] as List<dynamic>?)
    ?.map((e) => CompanionListItem.fromJson(e as Map<String, dynamic>))
    .toList() ?? []
```

## 响应类型

定义专门的响应类用于 API 返回数据：

```dart
/// 陪伴官列表响应
class CompanionListResponse {
  CompanionListResponse({
    required this.list,
    required this.total,
    required this.page,
    required this.size,
    required this.totalPages,
  });

  /// 陪伴官列表
  final List<CompanionListItem> list;

  /// 总数
  final int total;

  /// 当前页码
  final int page;

  /// 每页数量
  final int size;

  /// 总页数
  final int totalPages;

  factory CompanionListResponse.fromJson(Map<String, dynamic> json) {
    return CompanionListResponse(
      list: (json['list'] as List<dynamic>?)
              ?.map((e) => CompanionListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      size: json['size'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }
}
```

### 关键点

1. 包含分页信息（page、size、total、totalPages）
2. 为可选字段提供默认值（使用 `??` 运算符）
3. 列表字段提供空列表作为默认值

## 请求参数类

定义专门的参数类用于 API 请求：

```dart
/// 查询附近陪伴官参数
class QueryNearbyCompanionsParam {
  QueryNearbyCompanionsParam({
    required this.page,
    required this.size,
    this.longitude,
    this.latitude,
    this.radius,
    this.tags,
    this.serviceTypes,
  });

  /// 页码
  final int page;

  /// 每页条数
  final int size;

  /// 经度
  final double? longitude;

  /// 纬度
  final double? latitude;

  /// 搜索半径(km)
  final double? radius;

  /// 技能标签筛选
  final List<String>? tags;

  /// 服务类型筛选
  final List<String>? serviceTypes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'page': page, 'size': size};

    if (longitude != null) map['longitude'] = longitude;
    if (latitude != null) map['latitude'] = latitude;
    if (radius != null) map['radius'] = radius;
    if (tags != null && tags!.isNotEmpty) map['tags'] = tags;
    if (serviceTypes != null && serviceTypes!.isNotEmpty) {
      map['serviceTypes'] = serviceTypes;
    }

    return map;
  }
}
```

### 关键点

1. **toJson 方法**：用于序列化为 JSON
2. **条件添加**：只添加非空字段到 map 中
3. **列表检查**：列表字段需要检查是否为空

## 命名规范

### 类命名

- 数据模型：使用名词，如 `CompanionListItem`
- 响应类型：以 `Response` 结尾，如 `CompanionListResponse`
- 请求参数：以 `Param` 结尾，如 `QueryNearbyCompanionsParam`
- 枚举类型：使用名词，如 `CompanionStatus`

### 字段命名

- 使用小驼峰命名法（camelCase）
- 与后端 API 字段名保持一致
- 布尔字段使用 `is` 前缀（如 `isActive`）

## 最佳实践

1. **不可变性**：所有字段使用 `final`，确保数据不可变
2. **类型安全**：使用强类型，避免使用 `dynamic`
3. **空安全**：正确使用 `?` 和 `!` 运算符
4. **文档注释**：为所有公共类、枚举和字段添加注释
5. **默认值**：为可选字段提供合理的默认值
6. **分离关注点**：请求参数、响应数据、业务模型分开定义
7. **按模块组织**：将相关类型定义放在同一个文件中

## 使用示例

### 在 API 函数中使用

```dart
Future<CompanionListResponse> queryNearbyCompanions(
  QueryNearbyCompanionsParam params,
) async {
  final response = await HttpRequest.get<Map<String, dynamic>>(
    '/api/parent/companions',
    queryParameters: params.toJson(),
  );

  if (response.isSuccess && response.code == HttpResponseCode.succeed.code) {
    return CompanionListResponse.fromJson(response.data ?? {});
  }

  throw response.message ?? '服务器错误';
}
```

### 在组件中使用

```dart
Future<void> fetchData() async {
  try {
    final result = await queryNearbyCompanions(
      QueryNearbyCompanionsParam(page: 1, size: 10),
    );

    for (final item in result.list) {
      SystemLog.info('用户ID: ${item.userId}');
    }
  } catch (e) {
    SystemLog.error(e.toString());
  }
}
```

## 注意事项

1. 所有类型定义文件放在 `lib/types/` 目录下
2. 按功能模块组织类型定义文件
3. 使用 `factory` 构造函数实现 `fromJson`
4. 请求参数类实现 `toJson` 方法
5. 枚举类型包含 `value` 字段用于序列化
6. 列表类型转换时提供空列表作为默认值
7. 数字类型注意 `int` 和 `double` 的转换
