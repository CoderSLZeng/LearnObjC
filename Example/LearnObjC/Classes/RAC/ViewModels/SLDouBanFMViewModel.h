//
//  SLDouBanBookInfoViewModel.h
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/7/4.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Protocols
#import "SLViewModelProtocol.h"

#pragma mark - Frameworks
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLDouBanFMViewModel : NSObject <SLViewModelProtocol>
{
    RACCommand *_loadFMChannelDataCommand;
}

@property (strong, nonatomic, readonly) RACCommand *loadFMChannelDataCommand;
@end

NS_ASSUME_NONNULL_END
