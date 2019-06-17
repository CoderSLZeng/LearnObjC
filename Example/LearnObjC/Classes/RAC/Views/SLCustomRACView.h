//
//  SLCustomRACView.h
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/17.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

@class SLCustomRACView;
@protocol SLCustomRACViewDelegate <NSObject>

@optional
- (void)customRACViewDidTouchesBegan:(SLCustomRACView  * _Nonnull)view;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SLCustomRACView : UIView
/** 代理 */
@property (weak, nonatomic) id<SLCustomRACViewDelegate> delegate;

#pragma mark - RAC support
/** 信号 */
@property (strong, nonatomic) RACSubject *subject;
@end

NS_ASSUME_NONNULL_END
