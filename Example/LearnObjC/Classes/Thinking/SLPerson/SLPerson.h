//
//  SLPerson.h
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/15.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPerson : NSObject
{
    @public
    float _height;
}

@property (assign, nonatomic) NSInteger age;
@end

NS_ASSUME_NONNULL_END
