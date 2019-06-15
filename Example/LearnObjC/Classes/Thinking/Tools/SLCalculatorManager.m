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

- (BOOL)equal:(NSInteger)value {
    return self.result = value;
}

- (SLCalculatorManager * _Nonnull (^)(NSInteger))add {
    
    return ^(NSInteger value){
        self.result += value;
        return self;
    };
}

- (SLCalculatorManager *)calculatorBlock:(NSInteger (^)(NSInteger))block {
    
    self.result = block(self.result);
    return self;
}



@end
