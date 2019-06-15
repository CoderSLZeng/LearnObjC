//
//  SLFather.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/15.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLFather.h"

@implementation SLFather
- (void)printSuperOfSuperClass {
    
    NSLog(@"%@ %@ %@ %@",[self class],[self superclass],[super class],[super superclass]);
}
@end
