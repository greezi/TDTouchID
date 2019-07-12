//
//  TDMainViewController.m
//  TDTouchID
//
//  Created by imtudou on 2016/11/19.
//  Copyright © 2016年 TuDou. All rights reserved.
//

#import "TDMainViewController.h"
#import "TDTouchID.h"
#import "TDHomeViewController.h"

@interface TDMainViewController ()

@end

@implementation TDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"生物验证";
    
    UIButton *touchIDButton = [[UIButton alloc] init];
    [touchIDButton addTarget:self action:@selector(touchVerification) forControlEvents:UIControlEventTouchDown];
    touchIDButton.frame = CGRectMake((self.view.frame.size.width / 2) - 30, (self.view.frame.size.height / 2) - 30, 60, 60);
    [self.view addSubview:touchIDButton];
    
    
    //判断是否支持生物验证(此处根据不同类型来显示不同的图标)
    TDTouchIDSupperType type = [[TDTouchID sharedInstance] td_canSupperBiometrics];
    switch (type) {
        case TDTouchIDSupperTypeFaceID:
            NSLog(@"😄支持FaceID");
            [touchIDButton setBackgroundImage:[UIImage imageNamed:@"faceID"] forState:UIControlStateNormal];
            break;
        case TDTouchIDSupperTypeTouchID:
            NSLog(@"😄支持TouchID");
            [touchIDButton setBackgroundImage:[UIImage imageNamed:@"touchID"] forState:UIControlStateNormal];
            break;
        case TDTouchIDSupperTypeNone:
            NSLog(@"😭不支持生物验证");
            [touchIDButton setBackgroundImage:[UIImage imageNamed:@"touchID"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}


/**
 验证 TouchID
 */
- (void)touchVerification {
    
    [[TDTouchID sharedInstance] td_showTouchIDWithDescribe:@"通过Home键验证已有指纹" FaceIDDescribe:@"通过已有面容ID验证" BlockState:^(TDTouchIDState state, NSError *error) {
        if (state == TDTouchIDStateNotSupport) {    //不支持TouchID/FaceID
            
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"当前设备不支持生物验证" message:@"请输入密码来验证" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertview.alertViewStyle = UIAlertViewStyleSecureTextInput;
            [alertview show];
            
        } else if (state == TDTouchIDStateSuccess) {    //TouchID/FaceID验证成功
            
            NSLog(@"jump");
            TDHomeViewController *homeVc = [[TDHomeViewController alloc] init];
            [self.navigationController pushViewController:homeVc animated:YES];
            
        } else if (state == TDTouchIDStateInputPassword) { //用户选择手动输入密码
            
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertview.alertViewStyle = UIAlertViewStyleSecureTextInput;
            [alertview show];
            
        }
        
        // ps:以上的状态处理并没有写完全!
        // 在使用中你需要根据回调的状态进行处理,需要处理什么就处理什么
        
    }];
    
}

@end
