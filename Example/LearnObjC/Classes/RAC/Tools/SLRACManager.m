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


#pragma mark - RACCommand
/**
 RACCommand：处理事件总结
 
 注意
 1.RACCommand内部必须要返回signal
 2.executionSignals 信号中信号，一开始获取不到内部信号
    2.1 switchToLatest：获取内部信号
    2.2 execute：获取内部信号
 3.executing：判断是否正在执行
    3.1 第一次不准确，需要skip,跳过
    3.2 一定要记得sendCompleted,否则永远不会执行完成
 4.execute执行，执行command的block

 */
+ (void)useRACCommandWithExecute {
    // 创建RACCommand
    RACCommand *cmd = [self createRACCommand];

    // 执行：会调用执行RACCommand的block，并返回RACCommand的内部信号
    RACSignal *signal = [cmd execute:@"【useRACCommandWithExecute】"];
    
    // RACCommand的内部信号开始订阅，就会调用执行RACSignal的block
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

+ (void)useRACCommandWithExecutionSignals {
    // 创建RACCommand
    RACCommand *cmd = [self createRACCommand];
    
    /**
     订阅RACCommand信号
     
     @param executionSignals 信号中信号，信号发送信号
     @param x 发送信号
     */
    [cmd.executionSignals subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
        
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@", x);
        }];
    }];
    
    [cmd execute:@"【useRACCommandWithExecutionSignals】"];
    
}

+ (void)useRACCommandWithExecuting {
    // 创建RACCommand
    RACCommand *cmd = [self createRACCommand];
    
    [cmd.executing subscribeNext:^(NSNumber * _Nullable x) {
        BOOL isExecuting = [x boolValue];
        if (isExecuting) {
            NSLog(@"正在执行");
        } else {
            // 必须调用 [subscriber sendCompleted]; 才会来到这里，但不会忽略首次
            NSLog(@"执行完成");
        }
    }];
    
    [cmd execute:@"【useRACCommandWithExecuting】"];
    
}

+ (void)useRACCommandWithExecutingSkip {
    // 创建RACCommand
    RACCommand *cmd = [self createRACCommand];
    
    // 忽略首次信号：监听命令的执行情况，有没有完成
    [[cmd.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        BOOL isExecuting = [x boolValue];
        if (isExecuting) {
            NSLog(@"正在执行");
        } else {
            // 必须调用 [subscriber sendCompleted]; 才会来到这里
            NSLog(@"执行完成");
        }
    }];
    
    [cmd execute:@"【useRACCommandWithExecutingSkip】"];
    
}

+ (void)useRACCommandWithExecutionSignalsSwitchToLatest {
    // 创建RACCommand
    RACCommand *cmd = [self createRACCommand];
    
    /**
     订阅RACCommand信号
     
     @param executionSignals 信号中信号，信号发送信号
     @param switchToLatest 获取最近发送的信号
     @param x 接收信号发送的数据
     */
    [cmd.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [cmd execute:@"【useRACCommandWithExecutionSignalsSwitchToLatest】"];
    
}

#pragma mark - Private
+ (void)loadData:(void(^)(id))success {
    NSLog(@"加载数据");
}

+ (RACCommand *)createRACCommand {
    RACCommand *cmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        // RACCommand的block
        NSLog(@"执行RACCommand的block, input = %@", input);
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            // 信号的block
            NSLog(@"执行RACSignal的block，subscriber = %@", subscriber);
            // 发送数据 => RACReplaySubject
            [subscriber sendNext:@"发送数据 == Hello RACCommand"];
            // 发送完成
            [subscriber sendCompleted];
            
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"执行RACDisposable的block");
            }];
        }];
    }];
    return cmd;
}

+ (void)use_rac_flattenMap_map {
    // 信号中信号:信号发送一个信号
    RACSubject *signalOfSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    
//    [signalOfSignals subscribeNext:^(id  _Nullable x) {
//        NSLog(@"信号中信号的值:%@",x);
//        [x subscribeNext:^(id  _Nullable x) {
//            NSLog(@"信号的值:%@",x);
//        }];
//    }];
    
    // flattenMap，map获取都是信号的值
    [[signalOfSignals flattenMap:^RACSignal *(id value) {
        
//        __block NSString *result;
//        [value subscribeNext:^(id  _Nullable x) {
//            NSLog(@"%@",x);
//            result = [NSString stringWithFormat:@"SL:%@",x];
//        }];
//
//        NSLog(@"%@",result);
        
        return [value map:^id _Nullable(id  _Nullable value) {
            return [NSString stringWithFormat:@"SL:%@", value];
        }];
        
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    [signalOfSignals sendNext:signal];
    [signal sendNext:@1];
}


/**
 必须要第一个信号发送完成，第二个信号才能订阅
 */
+ (void)use_rac_concat {
    // 拼接concat
    // 需求:需要把两次请求的数据 添加到一个数组 有顺序的添加，先添加A，在添加B
    // 创建信号
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACReplaySubject subject];
    
    // 订阅信号
    NSMutableArray *arrM = [NSMutableArray array];
    
    // 按顺序拼接,必须要第一个信号发送完成，第二个信号才能获取值
    [[signalA concat:signalB] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
        [arrM addObject:x];
    }];
    
//    [signalA subscribeNext:^(id  _Nullable x) {
//        [arrM addObject:x];
//    }];
//
//
//    [signalB subscribeNext:^(id  _Nullable x) {
//        [arrM addObject:x];
//    }];
    
    // 发送信号
    [signalB sendNext:@"B"];
    [signalA sendNext:@"A"];
    [signalA sendCompleted];
    
    // 打印数组的值
    NSLog(@"%@",arrM);
}

+ (void)use_rac_concat2
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"执行信号A");
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"执行信号B");
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 尽量不要订阅多次
    [[signalA concat:signalB] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

+ (void)use_rac_concat3 {
    [[[self loadDetailData] concat:[self loadCategoryData]] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

/**
 then：
 1.拼接，忽略掉上一个信号的值
 2.解决block嵌套问题
 */
+ (void)use_rac_then {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"执行信号A");
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
//    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        NSLog(@"执行信号B");
//        [subscriber sendNext:@2];
//
//        return nil;
//    }];
    
    [[signalA then:^RACSignal * _Nonnull{
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"执行信号B");
            [subscriber sendNext:@2];
            return nil;
        }];
    }] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
        
    }];
}

/**
 请求界面数据:先请求分类,在请求详情
 */
+ (void)use_rac_then2 {
    
    // then:解决block嵌套问题
    // 请求界面数据:先请求分类,在请求详情
    
//    // 请求分类
//    [self loadCategoryData:^(id data) {
//
//        // 请求详情
//        [self loadDetailData:^(id data) {
//
//            [self loadDetailData:^(id data) {
//                [self loadDetailData:^(id data) {
//
//                    [self loadDetailData:^(id data) {
//
//
//                    }];
//                }];
//
//            }];
//        }];
//
//    }];


// RAC:
//    [[[[[self loadCategoryData] then:^RACSignal * _Nonnull{
//
//        return [self loadDetailData];
//
//    }] then:^RACSignal * _Nonnull{
//
//        return [self loadDetailData];
//
//    }] then:^RACSignal * _Nonnull{
//
//        return [self loadDetailData];
//
//    }] then:^RACSignal * _Nonnull{
//
//        return [self loadDetailData];
//
//    }];

    // RAC:then

// 请求的时候 一定要用RACReplaySubject
//    RACSubject *signalA = [RACReplaySubject subject];
//    RACSubject *signalB = [RACReplaySubject subject];
//
//    // 发送
//    [signalA sendNext:@"分类"];
//    [signalA sendCompleted];
//
//    [signalB sendNext:@"详情"];
//
//    [[signalA then:^RACSignal * _Nonnull{
//        return signalB;
//    }] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@", x);
//    }];
    
    [[[self loadCategoryData] then:^RACSignal * _Nonnull{

        return [self loadDetailData];

    }] subscribeNext:^(id  _Nullable x) {

        NSLog(@"%@", x);

    }];
}

/**
 合并,只要任何一个信号发送数据,就能订阅
 */
+ (void)use_rac_merge {
    // 只要想无序的整合信号数据
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    [[signalA merge:signalB] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    // 发送
    [signalB sendNext:@"B"];
    [signalA sendNext:@"A"];
}

/**
 压缩信号数据 变成 元组，同时发送数据，才能订阅到
 */
+ (void)use_rac_zipWith {
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    [[signalA zipWith:signalB] subscribeNext:^(id  _Nullable x) {
        
        RACTupleUnpack(NSString *a, NSString *b) = x;
        NSLog(@"%@ %@",a, b);
        
    }];
    
    [signalA sendNext:@"A"];
    [signalB sendNext:@"B"];
}

/**
 combineLatest：任何一个信号,只要改变就能订阅到
 (combineLatest, reduce)
 reduce：把多个信号的值,聚合为一个值
 reduce参数：把多个信号的值,聚合为一个值
 */
+ (void)use_rac_combineLatest_reduce {
    // 当前示例只是用来展示(combineLatest, reduce)的用法，并未实例这个3个对象
    UITextField *accountTF = [[UITextField alloc] init];
    UITextField *pwdTF = [[UITextField alloc] init];
    UIButton *loginBtn = [[UIButton alloc] init];
    // 监听账号文本框
    // 传统方式
    [accountTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if (x.length > 0) {
            
        }
    }];
    
    // 监听密码文本框
    [pwdTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if (x.length > 0) {
            
        }
    }];
    
    
    // 使用combineLatest 和 reduce 组合监听
    [[RACSignal combineLatest:@[accountTF.rac_textSignal, pwdTF.rac_textSignal] reduce:^id(NSString *account, NSString *pwd){
        
        NSLog(@"%@ %@",account, pwd);
        
        return @(account.length > 0 && pwd.length > 0);
        
    }] subscribeNext:^(id  _Nullable x) {
        loginBtn.enabled = [x boolValue];
        NSLog(@"聚合的结果 %@",x);
    }];
    
    // RAC:提醒，响应式编程
    RAC(loginBtn, enabled) = [RACSignal combineLatest:@[accountTF.rac_textSignal, pwdTF.rac_textSignal] reduce:^id(NSString *account,NSString *pwd){
        return @(account.length > 0 && pwd.length > 0);
    }];
    
    
}

#pragma mark - Private
//
/**
 请求分类数据

 @return 分类数据信号
 */
+ (RACSignal *)loadCategoryData {
    RACSubject *signal = [RACReplaySubject subject];
    
    // 发送请求
    [self loadCategoryData:^(id data) {
        [signal sendNext:data];
        [signal sendCompleted];
    }];
    
    return signal;
    
}

/**
 请求详情数据

 @return 详情数据信号
 */
+ (RACSignal *)loadDetailData {
    RACSubject *signal = [RACReplaySubject subject];
    
    // 发送请求
    [self loadDetailData:^(id data) {
        [signal sendNext:data];
        [signal sendCompleted];
    }];
    
    return signal;
}

// 请求分类
+ (void)loadCategoryData:(void(^)(id data))success {
    success(@"分类");
}

// 请求详情
+ (void)loadDetailData:(void(^)(id data))success {
    success(@"详情数据");
}

@end
