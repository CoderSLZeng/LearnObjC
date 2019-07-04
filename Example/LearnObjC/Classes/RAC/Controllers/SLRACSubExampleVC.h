//
//  SLRACSubExampleVC.h
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/7/4.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Frameworks
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLRACSubExampleVC : UIViewController


@property (strong, nonatomic) RACSubject *delegateSignal;

@end

NS_ASSUME_NONNULL_END
