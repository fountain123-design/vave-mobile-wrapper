# VAVE AI 移动应用

Flutter WebView 包装器，将 VAVE AI Web 应用打包为 iOS/Android 原生应用。

## 项目结构

```
vave-mobile-wrapper/
├── lib/
│   └── main.dart          # Flutter 主代码，WebView 包装器
├── android/               # Android 配置
├── ios/                   # iOS 配置
├── pubspec.yaml           # Flutter 依赖
├── codemagic.yaml         # Codemagic CI/CD 配置
└── README.md
```

## 关键配置

### 1. 修改 VAVE 应用地址

编辑 `lib/main.dart`，将 `VAVE_APP_URL` 替换为你的实际部署地址：

```dart
const String VAVE_APP_URL = 'https://your-vave-app.com';
```

当前使用的是临时 localtunnel 地址，部署后必须更新！

### 2. Codemagic 配置

在 Codemagic 控制台完成以下设置：

#### Android 签名（必需）
1. 生成 keystore：
```bash
keytool -genkey -v -keystore vave.keystore -alias vave -keyalg RSA -keysize 2048 -validity 10000
```

2. 在 Codemagic 控制台 → Settings → Code signing → Android keystores 上传

3. 在 `codemagic.yaml` 中引用 keystore 名称

#### iOS 签名（如需真机/上架）
- 需要 Apple Developer 账号（¥688/年）
- 在 Codemagic 上传证书和 provisioning profile

### 3. 构建触发

推送代码到 GitHub 后，Codemagic 自动触发构建：
- `main` 分支推送 → 构建 iOS + Android
- Tag 推送 → 构建 Release 版本

## 本地开发

```bash
# 获取依赖
flutter pub get

# 运行调试（需要连接设备或模拟器）
flutter run

# 构建 Android APK
flutter build apk --release

# 构建 iOS（需要 Mac + Xcode）
flutter build ios --release
```

## 部署流程

1. **部署 VAVE Web 应用到公网**（Vercel/Railway/腾讯云等）
2. **更新 `VAVE_APP_URL`** 为实际地址
3. **推送代码到 GitHub**
4. **Codemagic 自动构建** → 下载 IPA/APK

## 注意事项

- iOS 需要 Mac 环境构建，Codemagic 提供云端 Mac 构建机
- Android APK 可直接安装，iOS IPA 需要签名才能安装到真机
- 临时 localtunnel 地址会变化，生产环境必须使用固定域名
