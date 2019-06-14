//
//  SLCalculatorManager.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/14.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLCalculatorManager.h"

@implementation SLCalculatorManager

- (SLCalculatorManager *)add:(NSInteger)value {
    _result += value;
    return self;
}

- (SLCalculatorManager * _Nonnull (^)(NSInteger))add {
    
    return ^(NSInteger value){
        self.result += value;
        return self;
    };
}


@end
