//
//  SLRACManager.h
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/19.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLRACManager : NSObject

+ (void)useRACSignal;

+ (void)useRACSubject;

+ (void)useRACReplaySubject;

+ (void)useRACTuple;

+ (void)useRACMulticastConnection;

+ (void)useRACCommandWithExecute;

+ (void)useRACCommandWithExecutionSignals;

+ (void)useRACCommandWithExecuting;

+ (void)useRACCommandWithExecutingSkip;

+ (void)useRACCommandWithExecutionSignalsSwitchToLatest;

+ (void)use_rac_flattenMap_map;

+ (void)use_rac_concat;

+ (void)use_rac_concat2;

+ (void)use_rac_concat3;

+ (void)use_rac_then;

+ (void)use_rac_then2;

+ (void)use_rac_merge;

+ (void)use_rac_zipWith;

+ (void)use_rac_combineLatest_reduce;

@end

NS_ASSUME_NONNULL_END
