# Flutter 网络问题终极解决方案

## 问题现象

```
Could not HEAD 'https://storage.googleapis.com/download.flutter.io/...'
Got socket exception during request
Connection reset
```

## 根本原因

无法访问 Google 的 `storage.googleapis.com` 服务器下载 Flutter 引擎依赖。

## 解决方案汇总

### 方案 1：使用镜像（推荐）✅

已在项目中配置清华大学镜像：

**android/build.gradle.kts:**
```kotlin
allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            setUrl("https://mirrors.tuna.tsinghua.edu.cn/flutter/download.flutter.io")
        }
    }
}
```

**android/settings.gradle.kts:**
```kotlin
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
        maven {
            setUrl("https://mirrors.tuna.tsinghua.edu.cn/flutter/download.flutter.io")
        }
    }
}
```

**执行修复脚本:**
```bash
.\scripts\fix-network.bat
```

### 方案 2：手动配置环境变量

确保以下环境变量已设置：

```bash
# Windows (系统环境变量)
PUB_HOSTED_URL=https://mirrors.tuna.tsinghua.edu.cn/dart-pub/
FLUTTER_STORAGE_BASE_URL=https://mirrors.tuna.tsinghua.edu.cn/flutter/

# Linux/macOS (~/.bashrc 或 ~/.zshrc)
export PUB_HOSTED_URL=https://mirrors.tuna.tsinghua.edu.cn/dart-pub/
export FLUTTER_STORAGE_BASE_URL=https://mirrors.tuna.tsinghua.edu.cn/flutter/
```

**重启终端使环境变量生效！**

### 方案 3：使用其他镜像源

如果清华镜像不可用，尝试其他镜像：

#### 上海交大镜像
```bash
export PUB_HOSTED_URL=https://mirror.sjtu.edu.cn/dart-pub/
export FLUTTER_STORAGE_BASE_URL=https://mirror.sjtu.edu.cn/flutter/
```

#### 腾讯云镜像
```bash
export PUB_HOSTED_URL=https://mirrors.cloud.tencent.com/dart-pub/
export FLUTTER_STORAGE_BASE_URL=https://mirrors.cloud.tencent.com/flutter/
```

### 方案 4：配置 HTTP 代理

如果有可用的代理服务器：

**gradle.properties:**
```properties
systemProp.http.proxyHost=proxy.example.com
systemProp.http.proxyPort=8080
systemProp.https.proxyHost=proxy.example.com
systemProp.https.proxyPort=8080
```

**或使用环境变量:**
```bash
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
```

### 方案 5：离线构建（最后手段）

1. 在网络良好的环境（或使用 VPN）先构建一次
2. 将以下目录打包：
   - `~/.gradle/caches/`
   - `~/.pub-cache/`
   - `android/.gradle/`
3. 在目标环境解压到相应位置

## 完整修复流程

### 步骤 1：验证环境变量

```bash
# Windows
echo %PUB_HOSTED_URL%
echo %FLUTTER_STORAGE_BASE_URL%

# Linux/macOS
echo $PUB_HOSTED_URL
echo $FLUTTER_STORAGE_BASE_URL
```

应该输出：
```
https://mirrors.tuna.tsinghua.edu.cn/dart-pub/
https://mirrors.tuna.tsinghua.edu.cn/flutter/
```

### 步骤 2：验证 Gradle 配置

检查 `android/build.gradle.kts` 和 `android/settings.gradle.kts` 是否包含镜像配置。

### 步骤 3：清理所有缓存

```bash
# 停止 Gradle 守护进程
cd android && ./gradlew --stop && cd ..

# 清理 Flutter
flutter clean

# 删除 Gradle 缓存
rm -rf android/.gradle
rm -rf android/.kotlin
rm -rf android/build

# 删除 pub 缓存（可选，慎用）
# flutter pub cache clean
```

### 步骤 4：重新获取依赖

```bash
flutter pub get
```

### 步骤 5：尝试构建

```bash
npm run dev
# 或
flutter run --dart-define-from-file .env.development
```

## 常见问题排查

### Q1: 配置了镜像还是失败？

**可能原因：**
1. 环境变量未生效（需要重启终端）
2. Gradle 缓存了旧配置
3. 镜像服务器暂时不可用

**解决方法：**
```bash
# 1. 重启终端
# 2. 验证环境变量
echo $FLUTTER_STORAGE_BASE_URL

# 3. 测试镜像连接
curl -I https://mirrors.tuna.tsinghua.edu.cn/flutter/

# 4. 完全清理缓存
flutter clean
rm -rf ~/.gradle/caches/
rm -rf android/.gradle/
```

### Q2: 下载速度很慢？

**解决方法：**
1. 尝试其他镜像源（上海交大、腾讯云）
2. 增加 Gradle 内存（已在 gradle.properties 中配置）
3. 使用有线网络而非 WiFi

### Q3: 某些依赖仍然从 Google 下载？

**原因：** 某些插件可能硬编码了 Google 仓库

**解决方法：**
在 `android/build.gradle.kts` 的 `allprojects` 中，将镜像放在最前面：

```kotlin
allprojects {
    repositories {
        // 镜像放在最前面
        maven {
            setUrl("https://mirrors.tuna.tsinghua.edu.cn/flutter/download.flutter.io")
        }
        google()
        mavenCentral()
    }
}
```

### Q4: 错误提示 SSL 问题？

**解决方法：**
```bash
# 禁用 SSL 验证（仅用于测试）
export FLUTTER_STORAGE_BASE_URL_PATH_OVERRIDE=/
```

或在 `gradle.properties` 中添加：
```properties
systemProp.javax.net.ssl.trustStore=NONE
```

## 验证配置

### 检查 Flutter 配置

```bash
flutter doctor -v
```

### 检查 Gradle 配置

```bash
cd android
./gradlew properties | grep -i proxy
./gradlew properties | grep -i repository
```

### 测试网络连接

```bash
# 测试清华镜像
curl -I https://mirrors.tuna.tsinghua.edu.cn/flutter/

# 测试 Pub 镜像
curl -I https://mirrors.tuna.tsinghua.edu.cn/dart-pub/

# 测试 Google（应该失败）
curl -I https://storage.googleapis.com/
```

## 最终建议

如果以上所有方法都失败：

1. **使用 VPN** - 最直接的解决方案
2. **更换网络环境** - 尝试使用手机热点
3. **联系网络管理员** - 可能是公司/学校防火墙限制
4. **使用云端构建** - 如 GitHub Actions、GitLab CI

## 相关资源

- [Flutter 中国镜像](https://flutter.cn/community/china)
- [清华大学开源软件镜像站](https://mirrors.tuna.tsinghua.edu.cn/help/flutter/)
- [上海交大镜像站](https://mirror.sjtu.edu.cn/)
- [Gradle 配置文档](https://docs.gradle.org/current/userguide/build_environment.html)

## 快速命令参考

```bash
# 完整修复流程（一键执行）
.\scripts\fix-network.bat

# 手动执行
cd android && ./gradlew --stop && cd ..
flutter clean
rm -rf android/.gradle android/.kotlin android/build
flutter pub get
npm run dev
```
