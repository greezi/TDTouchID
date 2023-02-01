# TDTouchID

TDTouchID 是一个基于iOS平台的指纹、人脸验证库,可以用来做iOS APP的生物识别验证，例如：登录、支付、隐私空间等验证。

# ⚠️注意事项⚠️
* 使用面容ID 要在 info.plist 中添加权限
```
 <key>NSFaceIDUsageDescription</key>
 <string>应用程序需要面容ID权限才能使用人脸识别进行身份验证</string>
```

# 预览

|TouchID|FaceID|
|:---:|:---:|
|![](https://raw.githubusercontent.com/greezi/TDTouchID/master/IMG_3457.PNG)|![](https://raw.githubusercontent.com/greezi/TDTouchID/master/FaceID.gif)

# 安装方式
* 使用Cocoa Pods安装

```
pod 'TDTouchID', '~> 1.0.5'

```

* 手动导入      

将`TDTouchID`文件夹拖入项目.(里面包含`TDTouchID.h`和`TDTouchID.m`)文件

* 导入`#import "TDTouchID.h"`即可使用 



# 使用方法
```
- (void)td_showTouchIDWithDescribe:(NSString *)desc FaceIDDescribe:(NSString *)faceDesc AuthFallbackTitle:(NSString *)backTitle BlockState:(StateBlock)block;
```

详细使用方法请参见Demo

