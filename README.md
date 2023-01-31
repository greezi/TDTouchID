# TDTouchID

TDTouchID是一个封装好的指纹验证、人脸验证库,可以用来做iOSAPP的登录/支付等验证。

#预览
![(preview)](IMG_3457.PNG)

![(preview-Gif)](FaceID.gif)


#安装方式
* 使用Cocoa Pods安装
```
pod 'TDTouchID', '~> 1.0.4'

```
* 手动导入      

将`TDTouchID`文件夹拖入项目.(里面包含`TDTouchID.h`和`TDTouchID.m`)文件

* 导入`#import "TDTouchID.h"`即可使用 

#注意事项⚠️
* 使用面容ID 要在 info.plist 中添加权限
```
 <key>NSFaceIDUsageDescription</key>
 <string>应用程序需要面容ID权限才能使用人脸识别进行身份验证</string>
```

#如何使用
```
- (void)td_showTouchIDWithDescribe:(NSString *)desc FaceIDDescribe:(NSString *)faceDesc AuthFallbackTitle:(NSString *)backTitle BlockState:(StateBlock)block;
```

详细使用方法请参见Demo

