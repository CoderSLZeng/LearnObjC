//
//  SLCountryViewModel.h
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/19.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class SLCountryModel;
@interface SLCountryViewModel : NSObject<SLViewModelProtocol>

/** 数据模型 */
@property (strong, nonatomic) SLCountryModel *model;

@end

NS_ASSUME_NONNULL_END
