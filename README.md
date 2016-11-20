# TDTouchID

TDTouchID是一个封装好的指纹验证库,可以用来做iOSAPP的登录/支付等验证。

#如何使用
```
/**
 启动TouchID进行验证

 @param desc Touch显示的描述
 @param block 回调状态的block
 */

-(void)td_showTouchIDWithDescribe:(NSString *)desc BlockState:(StateBlock)block;
```
详细使用方法参见Demo即可
