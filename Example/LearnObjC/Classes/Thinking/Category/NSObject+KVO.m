//
//  NSObject+KVO.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/15.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/message.h>

@implementation NSObject (KVO)
- (void)sl_addObserver:(NSObject *)observer
         forKeyPath:(NSString *)keyPath
            options:(NSKeyValueObservingOptions)options
            context:(void *)context {
    /*
     1.runtime动态生成Person的子类(派生类)
     2.重写KVO_Person的属性set方法,目的:监听属性有没有改变
     3.修改对象的isa指针
     */
    // 修改isa
    object_setClass(self, NSClassFromString(@"NSKVONotifying_SLPerson"));
    
    // 保存观察者对象
    // self -> p;
    // 动态添加属性
    objc_setAssociatedObject(self, "observer", observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
