//
//  TDTouchID.h
//  TDTouchID
//
//  Created by imtudou on 2016/11/19.
//  Copyright © 2016年 TuDou. All rights reserved.
//


#import <LocalAuthentication/LocalAuthentication.h>

/****
 ⚠️⚠️⚠️
 注意: 使用面容ID 要在 info.plist 中添加权限
 
 <key>NSFaceIDUsageDescription</key>
 <string>应用程序需要面容ID权限才能使用人脸识别进行身份验证</string>
 
 */

/**
 *  设备支持的生物验证方式
 */
typedef enum : NSUInteger {
    /**
     *  支持TouchID验证
     */
    TDTouchIDSupperTypeTouchID = 1,
    /**
     *  支持FaceID验证
     */
    TDTouchIDSupperTypeFaceID,
    /**
     *  不支持支持验证
     */
    TDTouchIDSupperTypeNone,
} TDTouchIDSupperType;


/**
 *  TouchID 状态
 */
typedef enum : NSUInteger {
    /**
     *  当前设备不支持生物验证
     */
    TDTouchIDStateNotSupport = 1,
    /**
     *  生物验证 验证成功
     */
    TDTouchIDStateSuccess,
    /**
     *  生物验证 验证失败
     */
    TDTouchIDStateFail,
    /**
     *  生物验证 被用户手动取消
     */
    TDTouchIDStateUserCancel,
    /**
     *  用户不使用生物验证,选择手动输入密码
     */
    TDTouchIDStateInputPassword,
    /**
     *  生物验证 被系统取消 (如遇到来电,锁屏,按了Home键等)
     */
    TDTouchIDStateSystemCancel,
    /**
     *  生物验证 无法启动,因为用户没有设置密码
     */
    TDTouchIDStatePasswordNotSet,
    /**
     *  生物验证 无法启动,因为用户没有设置生物验证
     */
    TDTouchIDStateTouchIDNotSet,
    /**
     *  生物验证 无效
     */
    TDTouchIDStateTouchIDNotAvailable,
    /**
     *  生物验证 被锁定(连续多次验证生物验证失败,系统需要用户手动输入密码)
     */
    TDTouchIDStateTouchIDLockout,
    /**
     *  当前软件被挂起并取消了授权 (如App进入了后台等)
     */
    TDTouchIDStateAppCancel,
    /**
     *  当前软件被挂起并取消了授权 (LAContext对象无效)
     */
    TDTouchIDStateInvalidContext,
    /**
     *  系统版本不支持生物验证 (必须高于iOS 8.0才能使用)
     */
    TDTouchIDStateVersionNotSupport,
} TDTouchIDState;

@interface TDTouchID : LAContext

typedef void (^StateBlock)(TDTouchIDState state,NSError *error);

/// 单例
+ (instancetype)sharedInstance;


/// 是否显示日志信息
@property (nonatomic, assign) BOOL disableLogs;

/// 启动生物验证
/// - Parameters:
/// - desc: Touch显示的描述
/// - block: 回调状态的block
- (void)td_showTouchIDWithDescribe:(NSString *)desc BlockState:(StateBlock)block;


/// 启动生物验证
///- Parameters:
/// - desc: Touch显示的描述
/// - faceDesc: FaceID状态下显示的描述
/// - block: 回调状态的block
- (void)td_showTouchIDWithDescribe:(NSString *)desc FaceIDDescribe:(NSString *)faceDesc BlockState:(StateBlock)block;


/// 启动生物验证
///- Parameters:
/// - desc: Touch显示的描述
/// - faceDesc: FaceID状态下显示的描述
/// - backTitle: 错误一次之后,会显示 backTitle 按钮, 如果不想显示 backTitle 按钮,可以设置 backTitle = @""
/// - block: 回调状态的block
- (void)td_showTouchIDWithDescribe:(NSString *)desc FaceIDDescribe:(NSString *)faceDesc AuthFallbackTitle:(NSString *)backTitle BlockState:(StateBlock)block;


/// 判断设备支持的生物验证方式 (TouchID / FaceID / None)
- (TDTouchIDSupperType)td_canSupperBiometrics;


@end
