//
//  SLLoginViewModel.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/7/3.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLLoginViewModel.h"

#pragma mark - Frameworks
#import <SVProgressHUD/SVProgressHUD.h>

@interface SLLoginViewModel()
/** 视图 */
@property (weak, nonatomic) UIView *view;

/** 账号模型 */
@property (strong, nonatomic) SLAccountModel *accountModel;

@end

@implementation SLLoginViewModel

- (void)bindView:(UIView *)view {
    if ([view isMemberOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)view;
        if (0 == textField.tag) {
            UITextField *accountTF = textField;
            RAC(self.accountModel, account) = accountTF.rac_textSignal;
        } else {
            UITextField *pwdTF = textField;
            // 给模型的属性绑定信号
            // 只要账号文本框一改变，就会给account赋值
            RAC(self.accountModel, pwd) = pwdTF.rac_textSignal;
        }

    } else {
        UIButton *loginBtn = (UIButton *)view;
        // 绑定登录按钮
        RAC(loginBtn, enabled) = self.enableLoginSignal;
    }
}

- (RACCommand *)loginCommand {
    if (!_loginCommand) {
        // 处理登录业务逻辑
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//            NSLog(@"点击了登录");
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                // 模仿网络延迟
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [subscriber sendNext:@"登录成功"];
                    
                    // 数据传递完毕，必须调用完成，否则命令永远处于执行状态
                    [subscriber sendCompleted];
                });
                
                return nil;
            }];
        }];
        
        [[_loginCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
            if ([x isEqualToNumber:@(YES)]) {
                // 正在登录...
                // 用蒙版提示
                [SVProgressHUD showWithStatus:@"正在登录..."];
            } else {
            }
        }];
        
        [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            if ([x isEqualToString:@"登录成功"]) {
                
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            }
        }];
    }
    
    return _loginCommand;
}

- (RACSignal *)enableLoginSignal {
    if (!_enableLoginSignal) {
        // 监听账号的属性值改变，把他们聚合成一个信号
        _enableLoginSignal = [RACSignal combineLatest:@[RACObserve(self.accountModel, account), RACObserve(self.accountModel, pwd)] reduce:^id _Nonnull(NSString *account, NSString *pwd){
            return @(account.length && pwd.length);
        }];
    }
    return _enableLoginSignal;
}
- (void)initialBind {
    
    
}

- (SLAccountModel *)accountModel {
    if (!_accountModel) _accountModel = [[SLAccountModel alloc] init];
    
    return _accountModel;
}



@end
