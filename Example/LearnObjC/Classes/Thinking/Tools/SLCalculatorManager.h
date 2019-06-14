//
//  SLCalculatorManager.h
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/14.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLCalculatorManager : NSObject
/** 计算结果 */
@property (assign, nonatomic) NSInteger result;

- (SLCalculatorManager *)add:(NSInteger)value;

#pragma mark - 链式支持
- (SLCalculatorManager *(^)(NSInteger))add;

@end

NS_ASSUME_NONNULL_END
