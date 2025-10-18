### 一、Capacitor 核心优势（与 Android 开发结合）
1. **Web 技术原生化**：无需学习 Kotlin/Java，用熟悉的前端技术开发，通过 Capacitor 桥接调用 Android 原生 API（如相机、文件系统、通知等）。
2. **轻量灵活**：相比 Cordova，Capacitor 更贴近原生项目结构，修改原生代码更方便，且默认集成现代前端工具链（支持 Vite、Webpack 等）。
3. **无缝衔接 Android Studio**：生成标准的 Android 项目结构，可直接用 Android Studio 打开，享受原生开发工具的调试、打包能力。
4. **混合调试体验**：支持 Web 端（Chrome DevTools）和原生端（Android Studio Debugger）联合调试。


### 二、完整流程：Capacitor + Android Studio 开发打包步骤

#### 1. 环境准备
- **基础依赖**：
  - Node.js（v14+，推荐 v16+）：用于运行前端项目和 Capacitor 命令。
  - npm/yarn/pnpm：包管理工具。
  - Java Development Kit (JDK 11+)：Android Studio 依赖，需配置 `JAVA_HOME` 环境变量。
- **Android 环境**：
  - 安装 [Android Studio](https://developer.android.com/studio)（最新版）。
  - 打开 Android Studio 后，在 `SDK Manager` 中安装：
    - Android SDK（推荐 API 级别 21+，覆盖主流设备）。
    - Android Build Tools（与 SDK 版本匹配）。
    - 配置 `ANDROID_HOME` 环境变量（指向 SDK 安装路径，如 `C:\Users\用户名\AppData\Local\Android\Sdk`）。


#### 2. 创建 Capacitor 项目（以 Vue 为例，其他框架类似）
##### 步骤 1：创建前端项目
首先需要一个基础的 Web 项目（支持 Vue、React、Angular 等任意框架，甚至纯 HTML）：
```bash
# 创建 Vue 项目（示例）
npm create vue@latest my-capacitor-app
cd my-capacitor-app
npm install
npm run dev  # 确认项目能正常运行
```

##### 步骤 2：安装 Capacitor
在前端项目根目录执行：
```bash
# 安装 Capacitor 核心包和 CLI
npm install @capacitor/core @capacitor/cli
```

##### 步骤 3：初始化 Capacitor 配置
```bash
npx cap init
```
执行后会提示输入：
- **App Name**：应用名称（如 `MyApp`）。
- **App ID**：应用唯一标识（类似 Android 的包名，格式如 `com.example.myapp`）。
- **Web Dir**：前端打包输出目录（Vue 默认为 `dist`，React 为 `build`，需与项目实际打包路径一致）。

配置会保存在项目根目录的 `capacitor.config.ts` 文件中，可后续修改：
```typescript
// capacitor.config.ts
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.example.myapp',
  appName: 'MyApp',
  webDir: 'dist', // 前端打包后的目录
  server: {
    androidScheme: 'https' // 安卓端使用 https 协议加载本地 Web 资源
  }
};

export default config;
```

##### 步骤 4：构建前端项目
Capacitor 需要基于前端打包后的静态文件生成原生项目，因此先执行打包：
```bash
npm run build  # 生成 dist 目录（或其他配置的 webDir）
```


#### 3. 添加 Android 平台并关联 Android Studio
##### 步骤 1：创建 Android 项目
在前端项目根目录执行，生成 Android 原生项目：
```bash
npx cap add android
```
执行成功后，项目根目录会新增 `android` 文件夹，里面是标准的 Android 项目结构（可直接用 Android Studio 打开）。

##### 步骤 2：用 Android Studio 打开项目
- 打开 Android Studio，点击 `Open`，选择项目根目录下的 `android` 文件夹。
- 首次打开会自动同步 Gradle 依赖（耗时较长，需保证网络通畅，可配置国内镜像加速）。
- 同步完成后，Android Studio 会显示完整的项目结构（类似原生 Android 项目）。


#### 4. 开发与调试
##### （1）Web 内容实时更新（开发阶段）
开发时无需每次打包，可通过 Capacitor 代理实时加载前端开发服务器的内容：
```bash
# 启动前端开发服务器（如 Vue 的 npm run dev，默认端口 5173）
npm run dev

# 让 Android 项目加载本地开发服务器的内容（替代打包的静态文件）
npx cap run android --livereload --external
```
- `--livereload`：实时刷新页面。
- `--external`：允许外部设备（如真机）访问开发服务器。

执行后，Android Studio 会自动启动模拟器或连接的真机，应用将加载 `http://你的IP:5173` 的内容，修改前端代码后会实时更新。

##### （2）调试方式
- **Web 部分调试**：
  - 在 Chrome 中访问 `chrome://inspect`，找到对应的设备和应用，点击 `inspect` 打开 DevTools，可调试 HTML/CSS/JS。
- **原生部分调试**：
  - 在 Android Studio 中直接使用断点调试（如调用原生插件时），通过 `Logcat` 查看原生日志。


#### 5. 调用 Android 原生功能（插件使用）
Capacitor 内置了常用原生 API，也可通过社区插件扩展，以调用相机为例：
##### 步骤 1：安装相机插件
```bash
npm install @capacitor/camera
npx cap sync  # 同步插件到 Android 项目（每次安装新插件后需执行）
```

##### 步骤 2：在前端代码中调用
```javascript
// 示例：Vue 组件中调用相机
import { Camera, CameraResultType } from '@capacitor/camera';

const takePhoto = async () => {
  const image = await Camera.getPhoto({
    quality: 90,
    allowEditing: true,
    resultType: CameraResultType.Uri
  });
  // 显示照片（image.webPath 为图片路径）
  const imageUrl = image.webPath;
};
```

##### 步骤 3：处理原生权限
部分功能需要申请权限（如相机），Capacitor 会自动处理基础权限，如需自定义可在 `android/app/src/main/AndroidManifest.xml` 中添加：
```xml
<!-- 相机权限 -->
<uses-permission android:name="android.permission.CAMERA" />
```


#### 6. 打包 APK/AAB（发布到应用商店）
##### 步骤 1：生成签名密钥（首次打包需做）
- 在 Android Studio 中，点击 `Build > Generate Signed Bundle / APK`。
- 选择 `APK` 或 `Android App Bundle（AAB）`（Google Play 推荐 AAB）。
- 点击 `Create new...` 创建签名密钥（.jks 文件），填写密钥库密码、密钥别名、密钥密码等（务必牢记）。

##### 步骤 2：配置签名信息（可选，推荐）
为避免每次打包输入密码，可在 `android/app/build.gradle` 中配置签名信息：
```gradle
android {
    // ...
    signingConfigs {
        release {
            storeFile file('/path/to/your/key.jks') // 密钥库路径
            storePassword '你的密钥库密码'
            keyAlias '你的密钥别名'
            keyPassword '你的密钥密码'
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release // 关联签名配置
            // ...
        }
    }
}
```

##### 步骤 3：打包
- 点击 `Build > Generate Signed Bundle / APK`，选择已创建的签名密钥，点击 `Next`。
- 选择构建类型（`release` 为正式版，`debug` 为测试版）。
- 等待构建完成，输出路径为 `android/app/release/app-release.apk`（或 AAB 文件）。


#### 7. 版本更新与维护
- **前端代码更新**：修改前端代码后，执行 `npm run build` 重新打包，再执行 `npx cap sync android` 将新内容同步到 Android 项目。
- **Capacitor 版本更新**：通过 `npm update @capacitor/core @capacitor/android` 更新，再执行 `npx cap sync` 同步到原生项目。
- **原生代码修改**：如需自定义 Android 原生逻辑（如修改 Activity、添加第三方 SDK），可直接在 Android Studio 中编辑 `android` 目录下的文件（修改会被 Capacitor 保留，除非手动删除平台）。


### 三、注意事项
1. **Web 资源路径**：确保 `capacitor.config.ts` 中的 `webDir` 指向正确的前端打包目录，否则会出现白屏。
2. **权限管理**：除了在 `AndroidManifest.xml` 中声明权限，部分敏感权限（如位置、存储）还需在代码中动态申请（可使用 `@capacitor/permissions` 插件）。
3. **性能优化**：
   - 避免大型 Web 资源（如未压缩的图片、JS），影响加载速度。
   - 复杂交互场景可通过 Capacitor 插件调用原生组件（如地图、视频播放器）。
4. **兼容性**：Capacitor 对 Android 的最低支持版本是 API 21（Android 5.0），如需支持更低版本需额外配置。



## 四、滑动返回

```java
package com.huashidai.iFish;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Toast;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    
    private static final int BACK_PRESSED_INTERVAL = 2000; // 2秒内连续按返回键退出
    private long backPressedTime = 0;
    private Toast backToast;
    
    // 滑动相关变量
    private float startX = 0;
    private float startY = 0;
    private static final int MIN_SWIPE_DISTANCE = 100; // 最小滑动距离
    private static final int MAX_SWIPE_OFF_PATH = 200; // 最大偏离路径距离
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // 设置全屏模式（可选）
        hideSystemUI();
    }
    
    @Override
    public void onBackPressed() {
        // 检查是否在WebView中
        if (bridge.getWebView().canGoBack()) {
            // 如果WebView可以返回，则返回上一页
            bridge.getWebView().goBack();
        } else {
            // 如果WebView不能返回，则检查是否要退出应用
            if (backPressedTime + BACK_PRESSED_INTERVAL > System.currentTimeMillis()) {
                // 如果在2秒内再次按返回键，则退出应用
                if (backToast != null) {
                    backToast.cancel();
                }
                super.onBackPressed();
            } else {
                // 第一次按返回键，显示提示
                backToast = Toast.makeText(this, "再按一次返回键退出应用", Toast.LENGTH_SHORT);
                backToast.show();
                backPressedTime = System.currentTimeMillis();
            }
        }
    }
    
    @Override
    public boolean dispatchTouchEvent(MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                startX = event.getX();
                startY = event.getY();
                break;
            case MotionEvent.ACTION_UP:
                float endX = event.getX();
                float endY = event.getY();
                
                float deltaX = endX - startX;
                float deltaY = endY - startY;
                
                // 检查是否为水平滑动
                if (Math.abs(deltaX) > Math.abs(deltaY) && 
                    Math.abs(deltaX) > MIN_SWIPE_DISTANCE && 
                    Math.abs(deltaY) < MAX_SWIPE_OFF_PATH) {
                    
                    if (deltaX > 0) {
                        // 向右滑动 - 返回上一页
                        handleSwipeRight();
                    } else {
                        // 向左滑动 - 前进下一页（如果可能）
                        handleSwipeLeft();
                    }
                }
                break;
        }
        return super.dispatchTouchEvent(event);
    }
    
    /**
     * 处理向右滑动 - 返回上一页
     */
    private void handleSwipeRight() {
        if (bridge.getWebView().canGoBack()) {
            bridge.getWebView().goBack();
            showToast("返回上一页");
        } else {
            showToast("已经是第一页了");
        }
    }
    
    /**
     * 处理向左滑动 - 前进下一页
     */
    private void handleSwipeLeft() {
        if (bridge.getWebView().canGoForward()) {
            bridge.getWebView().goForward();
            showToast("前进下一页");
        } else {
            showToast("没有下一页了");
        }
    }
    
    /**
     * 显示提示信息
     */
    private void showToast(String message) {
        new Handler(Looper.getMainLooper()).post(() -> {
            Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
        });
    }
    
    /**
     * 隐藏系统UI（状态栏和导航栏）
     */
    private void hideSystemUI() {
        View decorView = getWindow().getDecorView();
        decorView.setSystemUiVisibility(
            View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
            | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
            | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
            | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
            | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
            | View.SYSTEM_UI_FLAG_FULLSCREEN
        );
    }
    
    /**
     * 当窗口焦点改变时重新隐藏系统UI
     */
    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus) {
            hideSystemUI();
        }
    }
}
```

