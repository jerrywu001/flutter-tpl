/// 环境配置
/// 用于管理应用的环境变量和固定配置
class Env {
  Env._();

  /// API 请求超时时间
  static const Duration timeout = Duration(seconds: 30);

  /// API Host URL (通过编译时环境变量注入)
  static const String hostUrl = String.fromEnvironment('API_HOST');

  /// 环境名称 (通过编译时环境变量注入)
  static const String envName = String.fromEnvironment('ENV_NAME');

  /// 是否打印错误日志
  static const bool printError = true;
}
