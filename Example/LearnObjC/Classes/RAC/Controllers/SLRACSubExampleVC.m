//
//  SLRACSubExampleVC.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/7/4.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLRACSubExampleVC.h"

@interface SLRACSubExampleVC ()
/** 关闭按钮 */
@property (weak, nonatomic) UIButton *closeBtn;

/** 通知按钮 */
@property (strong, nonatomic) UIButton *noticeBtn;

@end

@implementation SLRACSubExampleVC

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    
    @weakify(self)
    [[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [[self.noticeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.delegateSignal) {
            [self.delegateSignal sendNext:nil];
        }
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.closeBtn.frame = CGRectMake(20, 40, 60, 30);
    
    self.noticeBtn.frame = CGRectMake(50, 200, 300, 30);
}

#pragma mark - Getter
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor blueColor];
        [self.view addSubview:btn];
        _closeBtn = btn;
    }
    
    return _closeBtn;
}

- (UIButton *)noticeBtn {
    if (!_noticeBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"通知父控制器" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor blueColor];
        [self.view addSubview:btn];
        _noticeBtn = btn;
    }
    
    return _noticeBtn;
}



@end
