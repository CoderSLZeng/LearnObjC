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

#pragma mark - ReactiveObjC常见类
+ (void)use_RACSignal;

+ (void)use_RACSubject;

+ (void)use_RACReplaySubject;

+ (void)use_RACTuple;

+ (void)use_RACMulticastConnection;

+ (void)use_RACCommandWithExecute;

+ (void)use_RACCommandWithExecutionSignals;

+ (void)use_RACCommandWithExecuting;

+ (void)use_RACCommandWithExecutingSkip;

+ (void)use_RACCommandWithExecutionSignalsSwitchToLatest;

#pragma mark - ReactiveObjC核心方法之绑定
+ (void)use_rac_bind;

#pragma mark - ReactiveObjC操作方法之映射
+ (void)use_rac_flattenMap;

+ (void)use_rac_map;

+ (void)use_rac_flattenMap_map;

#pragma mark - ReactiveObjC操作方法之组合
+ (void)use_rac_concat;

+ (void)use_rac_concat2;

+ (void)use_rac_concat3;

+ (void)use_rac_then;

+ (void)use_rac_then2;

+ (void)use_rac_merge;

+ (void)use_rac_zipWith;

+ (void)use_rac_combineLatest;

+ (void)use_rac_reduce;

+ (void)use_rac_combineLatest_reduce;

#pragma mark - ReactiveObjC操作方法之过滤
+ (void)use_rac_filter;

+ (void)use_rac_ignore;

+ (void)use_rac_distinctUntilChanged;

+ (void)use_rac_take;

+ (void)use_rac_takeLast;

+ (void)use_rac_takeUntil;

+ (void)use_rac_use_rac_skip;

+ (void)use_rac_switchToLatest;

#pragma mark - ReactiveObjC操作方法之秩序
+ (void)use_rac_doNext_doCompleted;

#pragma mark - ReactiveObjC操作方法之线程
+ (void)use_rac_deliverOn_subscribeOn;

#pragma mark - ReactiveObjC操作方法之时间
+ (void)use_rac_timeout;

+ (void)use_rac_interval;

+ (void)use_rac_delay;

#pragma mark - ReactiveObjC操作方法之重复
+ (void)use_rac_retry;

+ (void)use_rac_replay;

+ (void)use_rac_throttle;
@end

NS_ASSUME_NONNULL_END
