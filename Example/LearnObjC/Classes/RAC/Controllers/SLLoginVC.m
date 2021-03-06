//
//  SLLoginVC.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/7/3.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

/**
 需求：
 1.监听两个文本框的内容，有内容才允许按钮点击
 2.默认登录请求
 
 用MVVM：实现，之前界面的所有业务逻辑
 分析：
 1.之前界面的所有业务逻辑都交给控制器做处理
 2.在MVVM架构中把控制器的业务全部搬去VM模型，也就是每个控制器对应一个VM模型.
 
 步骤：
 1.创建LoginViewModel类，处理登录界面业务逻辑.
 2.这个类里面应该保存着账号的信息，创建一个账号Account模型
 3.LoginViewModel应该保存着账号信息Account模型。
 4.需要时刻监听Account模型中的账号和密码的改变，怎么监听？
 5.在非RAC开发中，都是习惯赋值，在RAC开发中，需要改变开发思维，由赋值转变为绑定，可以在一开始初始化的时候，就给Account模型中的属性绑定，并不需要重写set方法。
 6.每次Account模型的值改变，就需要判断按钮能否点击，在VM模型中做处理，给外界提供一个能否点击按钮的信号.
 7.这个登录信号需要判断Account中账号和密码是否有值，用KVO监听这两个值的改变，把他们聚合成登录信号.
 8.监听按钮的点击，由VM处理，应该给VM声明一个RACCommand，专门处理登录业务逻辑.
 9.执行命令，把数据包装成信号传递出去
 10.监听命令中信号的数据传递
 11.监听命令的执行时刻
 */

#import "SLLoginVC.h"

#pragma mark - ViewModels
#import "SLLoginViewModel.h"

@interface SLLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

/** 视图模型 */
@property (strong, nonatomic) SLLoginViewModel *loginVM;

@end

@implementation SLLoginVC

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loginVM bindView:self.accountTF];
    self.pwdTF.tag = 1;
    [self.loginVM bindView:self.pwdTF];
    [self.loginVM bindView:self.loginBtn];
    
    @weakify(self);
    // 监听登录按钮点击
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"%@", x);
        // 执行登录事件
        [self.loginVM.loginCommand execute:nil];
    }];
}

#pragma mark - Getter
- (SLLoginViewModel *)loginVM {
    if (!_loginVM) _loginVM = [[SLLoginViewModel alloc] init];
    
    return _loginVM;
}


@end
