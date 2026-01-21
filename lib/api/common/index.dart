import 'package:dio/dio.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:ybx_parent_client/api/request/index.dart';
import 'package:ybx_parent_client/config/index.dart';
import 'package:ybx_parent_client/utils/index.dart';

/// 上传图片结果
class UploadImageResult {
  final bool success;
  final String? url;
  final String? message;

  UploadImageResult({required this.success, this.url, this.message});
}

/// 上传单张图片
///
/// [file] TDUploadFile 文件对象
///
/// [onProgress] 上传进度回调 (0-100)
///
/// 返回上传结果
Future<UploadImageResult> uploadImage(
  TDUploadFile file, {
  void Function(int progress)? onProgress,
}) async {
  if (file.file == null && file.assetPath == null) {
    return UploadImageResult(success: false, message: '文件不存在');
  }

  try {
    final filePath = file.file?.path ?? file.assetPath!;
    final fileName = filePath.split('/').last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });

    final response = await HttpRequest.dio.post<Map<String, dynamic>>(
      uploadFileUrls['normal']!,
      data: formData,
      onSendProgress: (sent, total) {
        if (onProgress != null && total > 0) {
          onProgress((sent / total * 100).round());
        }
      },
    );

    final httpResponse = HttpResponse<Map<String, dynamic>>.fromJson(
      response.data ?? {},
      (data) => data as Map<String, dynamic>,
    );

    if (!httpResponse.isSuccess ||
        httpResponse.code != HttpResponseCode.succeed.code) {
      throw httpResponse.message ?? '上传失败';
    }

    if (httpResponse.isSuccess &&
        httpResponse.code == HttpResponseCode.succeed.code) {
      // 根据实际接口返回格式调整
      final data = httpResponse.data;
      return UploadImageResult(
        success: true,
        url: data?['url'] ?? data?['fileUrl'],
        message: 'success',
      );
    }
  } catch (e) {
    SystemLog.error('上传图片失败: $e');
    return UploadImageResult(success: false, message: e.toString());
  }

  return UploadImageResult(success: false, message: '上传失败');
}

/// 批量上传图片
///
/// [files] TDUploadFile 文件列表
///
/// [onProgress] 总体上传进度回调 (0-100)
///
/// 返回上传结果列表
Future<List<UploadImageResult>> uploadImages(
  List<TDUploadFile> files, {
  void Function(int progress)? onProgress,
}) async {
  if (files.isEmpty) {
    return [];
  }

  final results = <UploadImageResult>[];
  var completedCount = 0;

  for (final file in files) {
    final result = await uploadImage(file);
    results.add(result);

    completedCount++;
    if (onProgress != null) {
      onProgress((completedCount / files.length * 100).round());
    }
  }

  return results;
}
