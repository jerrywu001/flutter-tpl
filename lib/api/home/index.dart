import 'package:ybx_parent_client/api/request/index.dart';
import 'package:ybx_parent_client/types/home/index.dart';

/// 查询附近陪伴官列表
Future<CompanionListResponse> queryNearbyCompanions(
  QueryNearbyCompanionsParam params,
) async {
  try {
    final response = await HttpRequest.get<Map<String, dynamic>>(
      '/api/parent/companions',
      queryParameters: params.toJson(),
    );

    if (!response.isSuccess || response.code != HttpResponseCode.succeed.code) {
      throw response.message ?? '服务器错误';
    }

    if (response.isSuccess && response.code == HttpResponseCode.succeed.code) {
      return CompanionListResponse.fromJson(response.data ?? {});
    }
  } catch (e) {
    rethrow;
  }

  // 返回空列表
  return CompanionListResponse(
    list: const [],
    total: 0,
    page: params.page,
    size: params.size,
    totalPages: 0,
  );
}
