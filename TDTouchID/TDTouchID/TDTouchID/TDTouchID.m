//
//  TDTouchID.m
//  TDTouchID
//
//  Created by imtudou on 2016/11/19.
//  Copyright © 2016年 TuDou. All rights reserved.
//

#import "TDTouchID.h"

@implementation TDTouchID

+ (instancetype)sharedInstance {
    static TDTouchID *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TDTouchID alloc] init];
    });
    return instance;
}

- (void)td_showTouchIDWithDescribe:(NSString *)desc FaceIDDescribe:(NSString *)faceDesc BlockState:(StateBlock)block {
    
    TDTouchIDSupperType supperType = [self td_canSupperBiometrics];
    
    NSString *descStr;
    if (supperType == TDTouchIDSupperTypeTouchID && desc.length == 0) {
        descStr = @"通过Home键验证已有指纹";
    }else{
        descStr = desc;
    }
    if (supperType == TDTouchIDSupperTypeFaceID && faceDesc.length == 0) {
        descStr = @"通过已有面容ID验证";
    }else{
        descStr = faceDesc;
    }
    
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"系统版本不支持TouchID (必须高于iOS 8.0才能使用)");
            block(TDTouchIDStateVersionNotSupport,nil);
        });
        
        return;
    }
    
    LAContext *context = [[LAContext alloc] init];
    
    context.localizedFallbackTitle = @"输入密码验证";
    
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:descStr reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"TouchID 验证成功");
                    block(TDTouchIDStateSuccess,error);
                });
            }else if(error){
                
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 验证失败");
                            block(TDTouchIDStateFail,error);
                        });
                        break;
                    }
                    case LAErrorUserCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被用户手动取消");
                            block(TDTouchIDStateUserCancel,error);
                        });
                    }
                        break;
                    case LAErrorUserFallback:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"用户不使用TouchID,选择手动输入密码");
                            block(TDTouchIDStateInputPassword,error);
                        });
                    }
                        break;
                    case LAErrorSystemCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                            block(TDTouchIDStateSystemCancel,error);
                        });
                    }
                        break;
                    case LAErrorPasscodeNotSet:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置密码");
                            block(TDTouchIDStatePasswordNotSet,error);
                        });
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置TouchID");
                            block(TDTouchIDStateTouchIDNotSet,error);
                        });
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无效");
                            block(TDTouchIDStateTouchIDNotAvailable,error);
                        });
                    }
                        break;
                    case LAErrorTouchIDLockout:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)");
                            block(TDTouchIDStateTouchIDLockout,error);
                        });
                    }
                        break;
                    case LAErrorAppCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                            block(TDTouchIDStateAppCancel,error);
                        });
                    }
                        break;
                    case LAErrorInvalidContext:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                            block(TDTouchIDStateInvalidContext,error);
                        });
                    }
                        break;
                    default:
                        break;
                }
            }
        }];
        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"当前设备不支持TouchID");
            block(TDTouchIDStateNotSupport,error);
        });
        
    }
    
}

- (void)td_showTouchIDWithDescribe:(NSString *)desc BlockState:(StateBlock)block{
    [self td_showTouchIDWithDescribe:desc FaceIDDescribe:nil BlockState:block];
}

// 判断设备支持哪种认证方式 TouchID & FaceID
- (TDTouchIDSupperType)td_canSupperBiometrics {
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        if (error != nil) {
            return TDTouchIDSupperTypeNone;
        }
        if (@available(iOS 11.0, *)) {
            return context.biometryType == LABiometryTypeFaceID ? TDTouchIDSupperTypeFaceID : TDTouchIDSupperTypeTouchID;
        }
    }
    return TDTouchIDSupperTypeNone;
}


@end
