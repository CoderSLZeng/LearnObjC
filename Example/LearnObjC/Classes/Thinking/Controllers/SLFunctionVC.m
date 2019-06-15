//
//  SLFunctionVC.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/14.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLFunctionVC.h"
#import "SLCalculatorManager.h"

@interface SLFunctionVC ()

@end

@implementation SLFunctionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    SLCalculatorManager *mgr = [[SLCalculatorManager alloc] init];
    BOOL isEqual = [[mgr calculatorBlock:^NSInteger(NSInteger result) {
        result += 5;
        result += 5;
        result += 5;
        result -= 5;
        return result;
    }] equal:10];
    
    NSLog(@"计算结果是相等 = %d", isEqual);
}


@end
