//
//  SLSon.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/15.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLSon.h"

@implementation SLSon

- (void)printSuperOfSuperClass {
    // self -> SLSon
    // super:还是当前对象，super只是一个标识
    // super:让当前对象去调用父类的方法
//    NSLog(@"输出结果：%@ %@ %@ %@",[self class],[self superclass],[super class],[super superclass]);
    // 输出结果：SLSon SLFather SLSon SLFather
    
    [super printSuperOfSuperClass];
    // 输出结果：SLSon SLFather SLSon SLFather
}

@end
