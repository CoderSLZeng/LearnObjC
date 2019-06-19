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

@end

NS_ASSUME_NONNULL_END
