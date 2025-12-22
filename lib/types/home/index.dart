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

/// 实名认证状态枚举
enum IdentityVerifyStatus {
  /// 未认证
  unverified('UNVERIFIED'),

  /// 已认证
  verified('VERIFIED'),

  /// 认证失败
  failed('FAILED');

  const IdentityVerifyStatus(this.value);
  final String value;
}

/// 在线状态枚举
enum OnlineStatus {
  /// 在线
  online('ONLINE'),

  /// 离线
  offline('OFFLINE'),

  /// 忙碌
  busy('BUSY');

  const OnlineStatus(this.value);
  final String value;
}

/// 在职状态枚举
enum EmploymentStatus {
  /// 在职
  active('ACTIVE'),

  /// 已离职
  resigned('RESIGNED');

  const EmploymentStatus(this.value);
  final String value;
}

/// 陪伴官列表项
class CompanionListItem {
  CompanionListItem({
    required this.id,
    required this.userId,
    this.nickname,
    this.avatar,
    this.realName,
    this.phone,
    this.avatarUrl,
    this.school,
    this.major,
    this.age,
    this.grade,
    this.introduction,
    this.tags,
    this.status,
    this.rejectReason,
    this.identityVerifyStatus,
    this.educationVerify,
    this.onlineStatus,
    this.employmentStatus,
    this.creditScore,
    this.orderCount,
    this.goodRate,
    this.hourlyRate,
    this.distance,
    this.examScore,
    this.serviceTypes,
    this.createdAt,
  });

  /// 陪伴官ID
  final String id;

  /// 用户ID
  final String userId;

  /// 昵称
  final String? nickname;

  /// 头像URL
  final String? avatar;

  /// 真实姓名
  final String? realName;

  /// 手机号
  final String? phone;

  /// 头像URL（兼容旧字段）
  final String? avatarUrl;

  /// 学校
  final String? school;

  /// 专业
  final String? major;

  /// 年龄
  final int? age;

  /// 年级
  final String? grade;

  /// 个人介绍
  final String? introduction;

  /// 技能标签
  final List<String>? tags;

  /// 审核状态
  final String? status;

  /// 驳回原因
  final String? rejectReason;

  /// 实名认证状态
  final String? identityVerifyStatus;

  /// 学籍认证状态
  final String? educationVerify;

  /// 在线状态
  final String? onlineStatus;

  /// 在职状态
  final String? employmentStatus;

  /// 信用分
  final int? creditScore;

  /// 接单数
  final int? orderCount;

  /// 好评率
  final String? goodRate;

  /// 时薪(元)
  final String? hourlyRate;

  /// 距离(km)
  final double? distance;

  /// 岗前考试分数
  final int? examScore;

  /// 服务类型
  final List<String>? serviceTypes;

  /// 创建时间
  final String? createdAt;

  factory CompanionListItem.fromJson(Map<String, dynamic> json) {
    return CompanionListItem(
      id: json['id'] as String,
      userId: json['userId'] as String,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      realName: json['realName'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      school: json['school'] as String?,
      major: json['major'] as String?,
      age: json['age'] as int?,
      grade: json['grade'] as String?,
      introduction: json['introduction'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      status: json['status'] as String?,
      rejectReason: json['rejectReason'] as String?,
      identityVerifyStatus: json['identityVerifyStatus'] as String?,
      educationVerify: json['educationVerify'] as String?,
      onlineStatus: json['onlineStatus'] as String?,
      employmentStatus: json['employmentStatus'] as String?,
      creditScore: json['creditScore'] as int?,
      orderCount: json['orderCount'] as int?,
      goodRate: json['goodRate'] as String?,
      hourlyRate: json['hourlyRate'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      examScore: json['examScore'] as int?,
      serviceTypes: (json['serviceTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] as String?,
    );
  }
}

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
      list:
          (json['list'] as List<dynamic>?)
              ?.map(
                (e) => CompanionListItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      size: json['size'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }
}

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
