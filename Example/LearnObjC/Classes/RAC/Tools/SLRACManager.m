//
//  SLRACManager.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/19.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLRACManager.h"

#pragma mark - Frameworks
#import <ReactiveObjC/ReactiveObjC.h>

@implementation SLRACManager


#pragma mark - Public
/**
 RACSignal：信号
 
 订阅RACSignal，自动创建RACSubscriber，由RACSubscriber发送信号消息
 
 RACSignal：只能订阅，不能发送
 RACSignal：只有一个订阅者
 */
+ (void)useRACSignal {
    /**
     信号 => 订阅 （响应式编程思想，只要信号一变化，马上通知你）
     RACSignal：信号，ReactiveCocoa最基本类
     RACDisposable：处理数据,清空数据
     RACSubscriber：订阅者,发送信号消息
     */
    
    // 1.创建信号：信号本身不具备发送消息能力
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"RACSignal的block");
        
        // 发送信号：会执行RACSignal subscribeNext的block
        [subscriber sendNext:@2];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            // 当订阅者被消耗的时候就会执行
            // 订阅发送完成或者error,也会执行Block
            // 清空数据
            NSLog(@"RACDisposable的block");
        }];
    }];
    
    /**
     订阅信号:会执行
     底层：创建订阅者RACSignal createSignal的block
     注意点：不要分开订阅，要一起订阅.
     */
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"信号传值的时候 %@",x);
    } error:^(NSError * _Nullable error) {
        // 订阅信号错误
    } completed:^{
        // 订阅完成
    }];
    
    /*
     不建议分开订阅：会造成多次发送消息和RACDisposables
     [signal subscribeNext:^(id  _Nullable x) {
     
     NSLog(@"信号传值的时候 %@",x);
     }];
     
     [signal subscribeError:^(NSError * _Nullable error) {
     
     }];
     
     [signal subscribeCompleted:^{
     
     }];
     */
}

/**
 RACSubject：有多个订阅者
 RACSubject和RACReplaySubject：
 
 RACSubject即可以订阅，也可以发送消息
 
 共同点：既可以充当信号也可以充当订阅者
 
 不同点：
 RACSubject：注意订阅和发送信号的顺序，先订阅，再发送信息
 RACReplaySubject：无需注意订阅和发送信号的顺序
 
 开发中：一个数据，需要多个类同时处理,使用RACSubject
 
 RACReplaySubject：保存值
 
 RACSubject开发的时候，使用的比较多
 
 RACSubject 代替代理
 */
+ (void)useRACSubject {
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第一个订阅者%@", x);
    }];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第二个订阅者%@", x);
    }];
    
    // 发送信号
    // 遍历所有信号订阅者
    [subject sendNext:@1];
    
}

/**
 RACReplaySubject：无需注意订阅和发送信号的顺序
 */
+ (void)useRACReplaySubject {
    // 创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    // 发送信号
    [replaySubject sendNext:@"123"];
    [replaySubject sendNext:@"321"];
}

/**
 RACTuple集合：是异步线程处理数据
 */
+ (void)useRACTuple {
    NSDictionary *dict = @{
                           @"name" : @"jack",
                           @"age"  : @18,
                           @"height" : @176,
                           };
    
    [dict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        // 把元组解析出来
        RACTupleUnpack(NSString *key, id value) = x;
        NSLog(@"把元组解析出来 key = %@, value = %@, 线程 = %@", key, value, [NSThread currentThread]);
        
        NSString *k = x[0];
        NSString *k2 = x[1];
        NSLog(@"把元组解析出来 k = %@, k2 = %@, 线程 = %@", k, k2, [NSThread currentThread]);
    }];
    
    // 把值包装成元组
    RACTuple *tuple = RACTuplePack(@1, @2, @3);
    NSLog(@"把值包装成元组 = %@, 线程 = %@", tuple, [NSThread currentThread]);
}

/**
 RACMulticastConnection：解决RACSignal被多次订阅的副作用
 */
+ (void)useRACMulticastConnection {
    
    @weakify(self)
    
    // 1.创建RACSignal信号
    // signal == RACDynamicSignal
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        @strongify(self)
        
        // 网络请求
        NSLog(@"发送请求");
        
        [self loadData:^(id data) {
            [subscriber sendNext:data];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
    
    // 2.RACSignal 转化 RACMulticastConnection
    RACMulticastConnection *connection = [signal publish];
    
    // 3.开始订阅RACSubject，这里并不会执行RACSignal的block
    // connection.signal == RACSubject，这里的connection.signal不是上面创建的RACSignal
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"next = %@", x);
    }];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"next = %@", x);
    }];
    
    // 4.进行连接，开始订阅RACSignal，才会执行的RACSignal的block
    [connection connect];
}

#pragma mark - Private
+ (void)loadData:(void(^)(id))success {
    NSLog(@"加载数据");
}



@end
