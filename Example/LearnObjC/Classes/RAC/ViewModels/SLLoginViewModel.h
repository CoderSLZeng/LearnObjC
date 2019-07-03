//
//  SLLoginViewModel.h
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/7/3.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Protocols
#import "SLViewModelProtocol.h"

#pragma mark - Models
#import "SLAccountModel.h"

#pragma mark - Frameworks
#import <ReactiveObjC/ReactiveObjC.h>


NS_ASSUME_NONNULL_BEGIN

@interface SLLoginViewModel : NSObject <SLViewModelProtocol>
{
    RACCommand *_loginCommand;
    RACSignal *_enableLoginSignal;
}

/** 是否允许登录的信号 */
@property (strong, nonatomic, readonly) RACSignal *enableLoginSignal;
/** 处理事件的信号 */
@property (strong, nonatomic, readonly) RACCommand *loginCommand;


@end

NS_ASSUME_NONNULL_END
