import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:ybx_parent_client/api/common/index.dart';
import 'package:ybx_parent_client/utils/index.dart';

/// 图片上传组件
///
/// 封装了 TDUpload，自动处理图片选择和上传
class ImageUploader extends StatefulWidget {
  const ImageUploader({
    super.key,
    this.max = 9,
    this.multiple = true,
    this.sizeLimit,
    this.wrapAlignment = WrapAlignment.start,
    this.initialFiles,
    this.onChanged,
    this.onUploadSuccess,
    this.onUploadError,
  });

  /// 最大上传数量
  final int max;

  /// 是否支持多选
  final bool multiple;

  /// 图片大小限制（KB）
  final double? sizeLimit;

  /// 图片对齐方式
  final WrapAlignment wrapAlignment;

  /// 初始图片列表
  final List<TDUploadFile>? initialFiles;

  /// 图片列表变化回调
  final void Function(List<TDUploadFile> files)? onChanged;

  /// 上传成功回调
  final void Function(TDUploadFile file, String url)? onUploadSuccess;

  /// 上传失败回调
  final void Function(TDUploadFile file, String message)? onUploadError;

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  List<TDUploadFile> _files = [];

  @override
  void initState() {
    super.initState();
    _files = widget.initialFiles ?? [];
  }

  void _handleChange(List<TDUploadFile> files, TDUploadType type) {
    setState(() {
      switch (type) {
        case TDUploadType.add:
          _files.addAll(files);
          // 上传图片
          for (final file in files) {
            _uploadFile(file);
          }
          break;
        case TDUploadType.remove:
          _files.removeWhere((f) => files.any((rf) => rf.key == f.key));
          break;
        case TDUploadType.replace:
          for (var newFile in files) {
            final index = _files.indexWhere((f) => f.key == newFile.key);
            if (index != -1) {
              _files[index] = newFile;
              _uploadFile(newFile);
            }
          }
          break;
      }
    });

    widget.onChanged?.call(_files);
  }

  Future<void> _uploadFile(TDUploadFile file) async {
    final result = await uploadImage(
      file,
      onProgress: (progress) {
        SystemLog.info('上传进度: $progress%');
      },
    );

    if (result.success && result.url != null) {
      SystemLog.success('上传成功: ${result.url}');
      widget.onUploadSuccess?.call(file, result.url!);
    } else {
      SystemLog.error('上传失败: ${result.message}');
      widget.onUploadError?.call(file, result.message ?? '上传失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TDUpload(
      files: _files,
      mediaType: [TDUploadMediaType.image],
      multiple: widget.multiple,
      max: widget.max,
      sizeLimit: widget.sizeLimit,
      wrapAlignment: widget.wrapAlignment,
      onError: (e) => SystemLog.error('选择图片错误: $e'),
      onValidate: (e) {
        if (e == TDUploadValidatorError.overSize) {
          TDToast.showText('图片大小超出限制', context: context);
        } else if (e == TDUploadValidatorError.overQuantity) {
          TDToast.showText('图片数量超出限制', context: context);
        }
      },
      onChange: _handleChange,
    );
  }
}
