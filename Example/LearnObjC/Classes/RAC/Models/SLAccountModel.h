//
//  SLAccountModel.h
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/7/3.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLAccountModel : NSObject

/** 账户 */
@property (copy, nonatomic) NSString *account;
/** 密码 */
@property (copy, nonatomic) NSString *pwd;

@end

NS_ASSUME_NONNULL_END
