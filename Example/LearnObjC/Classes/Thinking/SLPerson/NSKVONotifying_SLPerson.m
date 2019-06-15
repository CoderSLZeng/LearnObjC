//
//  NSKVONotifying_SLPerson.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/15.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "NSKVONotifying_SLPerson.h"
#import <objc/message.h>

@implementation NSKVONotifying_SLPerson

- (void)setAge:(NSInteger)age {
    [super setAge:age];

    // 调用观察者的observerValueForKeyPath
    id observer = objc_getAssociatedObject(self, "observer");

    [observer observeValueForKeyPath:@"age" ofObject:self change:nil context:nil];
     NSLog(@"执行NSKVONotifying_SLPerson");
}

@end
