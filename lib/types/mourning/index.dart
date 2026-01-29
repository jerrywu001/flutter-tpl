/// 哀悼日状态响应
class MourningStatusResponse {
  MourningStatusResponse({
    required this.isMourningDay,
    this.reason,
    this.startDate,
    this.endDate,
  });

  /// 是否是哀悼日
  final bool isMourningDay;

  /// 原因说明
  final String? reason;

  /// 开始日期（ISO 8601 格式）
  final String? startDate;

  /// 结束日期（ISO 8601 格式）
  final String? endDate;

  factory MourningStatusResponse.fromJson(Map<String, dynamic> json) {
    return MourningStatusResponse(
      isMourningDay: json['isMourningDay'] as bool? ?? false,
      reason: json['reason'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
    );
  }
}
