//
//  SLChianVC.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/14.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLChianVC.h"
#import "SLCalculatorManager.h"

@implementation SLChianVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self testNormal];
    [self testChian];
}

- (void)testNormal {
    SLCalculatorManager *mgr = [[SLCalculatorManager alloc] init];
    [[[mgr add:1] add:2] add:3];
    NSLog(@"普通思想的测试结果 = %ld", (long)mgr.result);
}

- (void)testChian {
    SLCalculatorManager *mgr = [[SLCalculatorManager alloc] init];
    mgr.add(1).add(2).add(3);
    NSLog(@"链式思想写法的测试结果 = %ld", (long)mgr.result);
}


@end
