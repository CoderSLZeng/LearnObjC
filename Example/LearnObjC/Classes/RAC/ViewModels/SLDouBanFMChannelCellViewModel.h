//
//  SLDouBanFMChannelCellViewModel.h
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/7/4.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Protocols
#import "SLViewModelProtocol.h"

@class SLDouBanFMChannelModel;
NS_ASSUME_NONNULL_BEGIN

@interface SLDouBanFMChannelCellViewModel : NSObject <SLViewModelProtocol>

@property (strong, nonatomic) SLDouBanFMChannelModel *model;

@end

NS_ASSUME_NONNULL_END
