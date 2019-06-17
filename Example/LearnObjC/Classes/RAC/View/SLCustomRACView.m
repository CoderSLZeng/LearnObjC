//
//  SLCustomView.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/17.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLCustomRACView.h"

@implementation SLCustomRACView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 使用代理
    if ([self.delegate respondsToSelector:@selector(customRACViewDidTouchesBegan:)]) {
        [self.delegate customRACViewDidTouchesBegan:self];
    }
    
    // 使用 RACSubject 发送信号
    [self.subject sendNext:self];
}

@end
