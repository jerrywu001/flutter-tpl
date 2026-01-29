import 'package:ybx_parent_client/api/request/index.dart';
import 'package:ybx_parent_client/types/mourning/index.dart';
import 'package:ybx_parent_client/utils/index.dart';

/// 查询哀悼日状态
Future<MourningStatusResponse> queryMourningStatus() async {
  try {
    final response = await HttpRequest.get<Map<String, dynamic>>(
      '/api/mourning/status',
    );

    if (!response.isSuccess || response.code != HttpResponseCode.succeed.code) {
      throw response.message ?? '查询哀悼日状态失败';
    }

    final result = MourningStatusResponse.fromJson(response.data ?? {});

    SystemLog.json(
      {
        'isMourningDay': result.isMourningDay,
        'reason': result.reason,
        'startDate': result.startDate,
        'endDate': result.endDate,
      },
      label: '哀悼日状态响应',
    );

    return result;
  } catch (e) {
    SystemLog.error('查询哀悼日状态失败: $e');
    rethrow;
  }
}
