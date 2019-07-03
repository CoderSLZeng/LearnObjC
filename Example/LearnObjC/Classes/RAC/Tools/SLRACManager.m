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
#import <ReactiveObjC/RACReturnSignal.h>

@implementation SLRACManager

#pragma mark - 接口
#pragma mark - ReactiveObjC常见类
/**
 RACSignal：信号
 
 订阅RACSignal，自动创建RACSubscriber，由RACSubscriber发送信号消息
 
 RACSignal：只能订阅，不能发送
 RACSignal：只有一个订阅者
 */
+ (void)use_RACSignal {
    /**
     信号 => 订阅 （响应式编程思想，只要信号一变化，马上通知你）
     RACSignal：信号，ReactiveObjC最基本类
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
+ (void)use_RACSubject {
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
+ (void)use_RACReplaySubject {
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
+ (void)use_RACTuple {
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
+ (void)use_RACMulticastConnection {
    
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


#pragma mark RACCommand
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
+ (void)use_RACCommandWithExecute {
    // 创建RACCommand
    RACCommand *cmd = [self createRACCommand];

    // 执行：会调用执行RACCommand的block，并返回RACCommand的内部信号
    RACSignal *signal = [cmd execute:@"【useRACCommandWithExecute】"];
    
    // RACCommand的内部信号开始订阅，就会调用执行RACSignal的block
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

+ (void)use_RACCommandWithExecutionSignals {
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

+ (void)use_RACCommandWithExecuting {
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

+ (void)use_RACCommandWithExecutingSkip {
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

+ (void)use_RACCommandWithExecutionSignalsSwitchToLatest {
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

#pragma mark - ReactiveObjC核心方法之绑定
+ (void)use_rac_bind {
    
    UITextField *textField = [[UITextField alloc] init];
    // 假设想监听文本框的内容，并且在每次输出结果的时候，都在文本框的内容拼接一段文字“输出：”
    
    // 方式一:在返回结果后，拼接。
    [textField.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"输出:%@",x);
        
    }];
    
    // 方式二:在返回结果前，拼接，使用RAC中bind方法做处理。
    // bind方法参数:需要传入一个返回值是RACSignalBindBlock的block参数
    // RACSignalBindBlock是一个block的类型，返回值是信号，参数（value,stop），因此参数的block返回值也是一个block。
    
    // RACSignalBindBlock:
    // 参数一(value):表示接收到信号的原始值，还没做处理
    // 参数二(*stop):用来控制绑定Block，如果*stop = yes,那么就会结束绑定。
    // 返回值：信号，做好处理，在通过这个信号返回出去，一般使用RACReturnSignal,需要手动导入头文件RACReturnSignal.h。
    
    // bind方法使用步骤:
    // 1.传入一个返回值RACSignalBindBlock的block。
    // 2.描述一个RACSignalBindBlock类型的bindBlock作为block的返回值。
    // 3.描述一个返回结果的信号，作为bindBlock的返回值。
    // 注意：在bindBlock中做信号结果的处理。
    
    // 底层实现:
    // 1.源信号调用bind,会重新创建一个绑定信号。
    // 2.当绑定信号被订阅，就会调用绑定信号中的didSubscribe，生成一个bindingBlock。
    // 3.当源信号有内容发出，就会把内容传递到bindingBlock处理，调用bindingBlock(value,stop)
    // 4.调用bindingBlock(value,stop)，会返回一个内容处理完成的信号（RACReturnSignal）。
    // 5.订阅RACReturnSignal，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
    
    // 注意:不同订阅者，保存不同的nextBlock，看源码的时候，一定要看清楚订阅者是哪个。
    // 这里需要手动导入#import <ReactiveObjC/RACReturnSignal.h>，才能使用RACReturnSignal。
    
    [[textField.rac_textSignal bind:^RACSignalBindBlock{
        
        // 什么时候调用:
        // block作用:表示绑定了一个信号.
        
        return ^RACSignal *(id value, BOOL *stop){
            
            // 什么时候调用block:当信号有新的值发出，就会来到这个block。
            
            // block作用:做返回值的处理
            
            // 做好处理，通过信号返回出去.
            return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
        };
        
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
}

#pragma mark - ReactiveObjC操作方法之映射
/**
 flattenMap作用:把源信号的内容映射成一个新的信号，信号可以是任意类型。
 flattenMap使用步骤:
 1.传入一个block，block类型是返回值RACStream，参数value
 2.参数value就是源信号的内容，拿到源信号的内容做处理
 3.包装成RACReturnSignal信号，返回出去。
 
 flattenMap底层实现:
 0.flattenMap内部调用bind方法实现的，flattenMap中block的返回值，会作为bind中bindBlock的返回值。
 1.当订阅绑定信号，就会生成bindBlock。
 2.当源信号发送内容，就会调用bindBlock(value, *stop)
 3.调用bindBlock，内部就会调用flattenMap的block，flattenMap的block作用：就是把处理好的数据包装成信号。
 4.返回的信号最终会作为bindBlock中的返回信号，当做bindBlock的返回信号。
 5.订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
 */
+ (void)use_rac_flattenMap {
    UITextField *textField = [[UITextField alloc] init];
    [[textField.rac_textSignal flattenMap:^__kindof RACStream * _Nullable(NSString * _Nullable value) {
        // block什么时候 : 源信号发出的时候，就会调用这个block。
        // block作用 : 改变源信号的内容。
        NSString *result = [NSString stringWithFormat:@"输出:%@",value];
        // 返回值：绑定信号的内容.
        return [RACReturnSignal return:result];
        
    }] subscribeNext:^(id x) {
        
        // 订阅绑定信号，每当源信号发送内容，做完处理，就会调用这个block。
        NSLog(@"%@",x);
    }];
}

/**
 map作用:把源信号的值映射成一个新的值
 
 map使用步骤:
 1.传入一个block,类型是返回对象，参数是value
 2.value就是源信号的内容，直接拿到源信号的内容做处理
 3.把处理好的内容，直接返回就好了，不用包装成信号，返回的值，就是映射的值。
 
 map底层实现:
 0.map底层其实是调用flatternmap，map中block中的返回的值会作为flatternmap中block中的值。
 1.当订阅绑定信号，就会生成bindBlock。
 3.当源信号发送内容，就会调用bindBlock(value, *stop)
 4.调用bindBlock，内部就会调用flattenMap的block
 5.flattenMap的block内部会调用map中的block，把map中的block返回的内容包装成返回的信号。
 6.返回的信号最终会作为bindBlock中的返回信号，当做bindBlock的返回信号。
 7.订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
 */
+ (void)use_rac_map {
    UITextField *textField = [[UITextField alloc] init];
    [[textField.rac_textSignal map:^id(id value) {
        // 当源信号发出，就会调用这个block，修改源信号的内容
        // 返回值：就是处理完源信号的内容。
        return [NSString stringWithFormat:@"输出:%@",value];
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

/**
 flatternmap + map 组合使用
 flatternmap和map的区别
 1.flatternmap中的Block返回信号。
 2.map中的Block返回对象。
 3.开发中，如果信号发出的值不是信号，映射一般使用map
 4.开发中，如果信号发出的值是信号，映射一般使用flatternmap。
 
 总结：signalOfsignals用flatternmap。
 */
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

#pragma mark - ReactiveObjC操作方法之组合
/**
 按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
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
    
    // 把signalA拼接到signalB后，signalA发送完成，signalB才会被激活。
    RACSignal *concatSignal = [signalA concat:signalB];
    
    // 以后只需要面对拼接信号开发。
    // 订阅拼接的信号，不需要单独订阅signalA，signalB
    // 内部会自动订阅。
    // 注意：第一个信号必须发送完成，第二个信号才会被激活
    [concatSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    // concat底层实现:
    // 1.当拼接信号被订阅，就会调用拼接信号的didSubscribe
    // 2.didSubscribe中，会先订阅第一个源信号（signalA）
    // 3.会执行第一个源信号（signalA）的didSubscribe
    // 4.第一个源信号（signalA）didSubscribe中发送值，就会调用第一个源信号（signalA）订阅者的nextBlock,通过拼接信号的订阅者把值发送出来.
    // 5.第一个源信号（signalA）didSubscribe中发送完成，就会调用第一个源信号（signalA）订阅者的completedBlock,订阅第二个源信号（signalB）这时候才激活（signalB）。
    // 6.订阅第二个源信号（signalB）,执行第二个源信号（signalB）的didSubscribe
    // 7.第二个源信号（signalA）didSubscribe中发送值,就会通过拼接信号的订阅者把值发送出来.
}

+ (void)use_rac_concat3 {
    [[[self loadDetailData] concat:[self loadCategoryData]] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

/**
 then：用于连接两个信号，当第一个信号完成，才会连接then返回的信号。
 注意使用then，之前信号的值会被忽略掉.
 底层实现：1、先过滤掉之前的信号发出的值。2.使用concat连接then返回的信号
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
        
        // 只能接收到第二个信号的值，也就是then返回信号的值
        NSLog(@"%@",x);
        
    }];
}

/**
 解决block嵌套问题
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
 merge：把多个信号合并为一个信号，任何一个信号有新值的时候就会调用
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
    
    // 底层实现：
    // 1.合并信号被订阅的时候，就会遍历所有信号，并且发出这些信号。
    // 2.每发出一个信号，这个信号就会被订阅
    // 3.也就是合并信号一被订阅，就会订阅里面所有的信号。
    // 4.只要有一个信号被发出就会被监听。
}

/**
 zipWith：把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。
 */
+ (void)use_rac_zipWith {
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    // 压缩信号A，信号B
    RACSignal *zipSignal = [signalA zipWith:signalB];
    
    [zipSignal subscribeNext:^(id  _Nullable x) {
        
        RACTupleUnpack(NSString *a, NSString *b) = x;
        NSLog(@"%@ %@",a, b);
        
    }];
    
    [signalA sendNext:@"A"];
    [signalB sendNext:@"B"];
    
    // 底层实现:
    // 1.定义压缩信号，内部就会自动订阅signalA，signalB
    // 2.每当signalA或者signalB发出信号，就会判断signalA，signalB有没有发出个信号，有就会把最近发出的信号都包装成元组发出。
}

/**
 combineLatest：将多个信号合并起来，并且拿到各个信号的最新的值，必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。
 */
+ (void)use_rac_combineLatest {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 把两个信号组合成一个信号,跟zip一样，没什么区别
    RACSignal *combineSignal = [signalA combineLatestWith:signalB];
    
    [combineSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 底层实现：
    // 1.当组合信号被订阅，内部会自动订阅signalA，signalB，必须两个信号都发出内容，才会被触发。
    // 2.并且把两个信号组合成元组发出。
}

/**
 reduce聚合：用于信号发出的内容是元组，把信号发出元组的值聚合成一个值
 */
+ (void)use_rac_reduce {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 聚合
    // 常见的用法，（先组合在聚合）。combineLatest:(id<NSFastEnumeration>)signals reduce:(id (^)())reduceBlock
    // reduce中的block简介:
    // reduceblcok中的参数，有多少信号组合，reduceblcok就有多少参数，每个参数就是之前信号发出的内容
    // reduceblcok的返回值：聚合信号之后的内容。
    RACSignal *reduceSignal = [RACSignal combineLatest:@[signalA,signalB] reduce:^id(NSNumber *num1 ,NSNumber *num2){
        
        return [NSString stringWithFormat:@"%@ %@",num1,num2];
        
    }];
    
    [reduceSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 底层实现:
    // 1.订阅聚合信号，每次有内容发出，就会执行reduceblcok，把信号内容转换成reduceblcok返回的值。
}


/**
 combineLatest + reduce 组合使用
 */
+ (void)use_rac_combineLatest_reduce {
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

#pragma mark - ReactiveObjC操作方法之过滤
/**
 filter：过滤信号，使用它可以获取满足条件的信号，能少用if。
 */
+ (void)use_rac_filter {
    UITextField *pwdTF = [[UITextField alloc] init];
    
    // 密码长度小于6,不处理
    // YES:才会允许通过,发送数据
    // No:根本就不会发送
    [[pwdTF.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        // 必须要满足这个条件,才可以发送数据出去
        return value.length > 6;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

/**
 ignore：忽略完某些值的信号
 */
+ (void)use_rac_ignore {
    UITextField *textTF = [[UITextField alloc] init];
    // 内部调用filter过滤，忽略掉ignore的值
    [[textTF.rac_textSignal ignore:@"1"] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

/**
 distinctUntilChanged：当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉。
 */
+ (void)use_rac_distinctUntilChanged {
    UITextField *textTF = [[UITextField alloc] init];
    // 内部调用filter过滤，忽略掉ignore的值
    [[textTF.rac_textSignal distinctUntilChanged] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

/**
 take：从开始一共取N次的信号
 */
+ (void)use_rac_take {
    // 1、创建信号
    RACSubject *signal = [RACSubject subject];
    
    // 2、处理信号，订阅信号
    [[signal take:1] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 3.发送信号
    [signal sendNext:@1];
    
    [signal sendNext:@2];
}

/**
 takeLast：取最后N次的信号，前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号。
 */
+ (void)use_rac_takeLast {
    // 1、创建信号
    RACSubject *signal = [RACSubject subject];
    
    // 2、处理信号，订阅信号
    [[signal takeLast:1] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 3.发送信号
    [signal sendNext:@1];
    
    [signal sendNext:@2];
    
    [signal sendCompleted];
}

/**
 takeUntil:(RACSignal *)：获取信号直到某个信号执行完成
 */
+ (void)use_rac_takeUntil {
    UITextField *textField = [[UITextField alloc] init];
    // 监听文本框的改变直到当前对象被销毁
    RACSignal *signal = [textField.rac_textSignal takeUntil:self.rac_willDeallocSignal];
    NSLog(@"%@", signal);
}

/**
 skip:(NSUInteger)：跳过几个信号,不接受。
 */
+ (void)use_rac_use_rac_skip {
    UITextField *textField = [[UITextField alloc] init];
    
    [[textField.rac_textSignal skip:1] subscribeNext:^(NSString * _Nullable x) {
       NSLog(@"%@",x);
    }];

}

/**
 switchToLatest：用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号。
 */
+ (void)use_rac_switchToLatest {
    RACSubject *signalOfSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    
    // 获取信号中信号最近发出信号，订阅最近发出的信号。
    // 注意switchToLatest：只能用于信号中的信号
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [signalOfSignals sendNext:signal];
    [signal sendNext:@1];
}

#pragma mark - ReactiveObjC操作方法之秩序
/**
 doNext：执行Next之前，会先执行这个Block
 doCompleted：执行sendCompleted之前，会先执行这个Block
 */
+ (void)use_rac_doNext_doCompleted {
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] doNext:^(id x) {
        // 执行[subscriber sendNext:@1];之前会调用这个Block
        NSLog(@"doNext");;
    }] doCompleted:^{
        // 执行[subscriber sendCompleted];之前会调用这个Block
        NSLog(@"doCompleted");;
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

#pragma mark - ReactiveObjC操作方法之线程
/**
 副作用：关于信号与线程,我们把在创建信号时block中的代码称之为副作用。
 deliverOn: 切换到指定线程中，可用于回到主线中刷新UI，内容传递切换到指定线程中。
 subscribeOn: 内容传递和副作用都会切换到制定线程中。
 deliverOnMainThread：能保证原信号subscribeNext，sendError，sendCompleted都在主线程MainThread中执行。
 */
+ (void)use_rac_deliverOn_subscribeOn {
    // 测试1：系统并行队列中异步执行，未使用deliverON切换线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"测试1-endNext"];
            NSLog(@"测试1-当前线程：%@", [NSThread currentThread]);
            return nil;
        }] subscribeNext:^(id  _Nullable x) {
            NSLog(@"测试1-Next:%@", x);
            NSLog(@"测试1-Next当前线程：%@", [NSThread currentThread]);
        }];
    });
    
    // 测试2：系统并行队列中异步执行，使用deliverON切换线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"测试2-endNext"];
            NSLog(@"测试2-当前线程：%@",[NSThread currentThread]);
            return nil;
        }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
            NSLog(@"测试2-Next:%@",x);
            NSLog(@"测试2-Next当前线程：%@",[NSThread currentThread]);
        }];
    });
    
    //测试3：系统并行队列中异步执行,使用subscribeOn切换线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"测试3-sendNext"];
            NSLog(@"测试3-sendNext当前线程：%@",[NSThread currentThread]);
            return nil;
        }] subscribeOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id  _Nullable x) {
            NSLog(@"测试3-Next:%@",x);
            NSLog(@"测试3-Next当前线程：%@",[NSThread currentThread]);
        }];
    });

    /**
     分析：
     测试1：未切换线程，发送消息与接收消息都在异步线程中
     测试2：使用deliverON，发送消息还在原来的线程，但是接收消息切换到主线程。
     测试3：使用subscribeON，发送消息和接收消息都被切换到了主线程中执行。
     */
}

#pragma mark - ReactiveObjC操作方法之时间
/**
 timeout：超时，可以让一个信号在一定的时间后，自动报错。
 */
+ (void)use_rac_timeout {
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }] timeout:1 onScheduler:[RACScheduler currentScheduler]];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        // 1秒后会自动调用
        NSLog(@"%@",error);
    }];
}

/**
 interval 定时：每隔一段时间发出信号
 */
+ (void)use_rac_interval {
    // 定时器
    // [NSTimer scheduledTimerWithTimeInterval:<#(NSTimeInterval)#> target:<#(nonnull id)#> selector:<#(nonnull SEL)#> userInfo:<#(nullable id)#> repeats:<#(BOOL)#>]
    
    // interval：隔多少秒发送消息
    // RACScheduler：多线程,管理现场
    [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        
        NSLog(@"执行了定时器");
        
    }];
}

/**
 delay：延迟发送数据next
 */
+ (void)use_rac_delay {
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"执行signalBlock");
        [subscriber sendNext:@"延迟2秒后再发送数据"];
        return nil;
    }] delay:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - ReactiveObjC操作方法之重复
/**
 retry重试：只要失败，就会重新执行创建信号中的block，直到成功。
 */
+ (void)use_rac_retry {
    __block int i = 0;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (i == 10) {
            [subscriber sendNext:@1];
        } else {
            NSLog(@"接收到错误");
            [subscriber sendError:nil];
        }
        i++;
        
        return nil;
        
    }] retry] subscribeNext:^(id x) {
        
        NSLog(@"%@", x);
        
    } error:^(NSError *error) {
        
        NSLog(@"%@", error);
    }];
}

/**
 replay重放：当一个信号被多次订阅，反复播放内容
 */
+ (void)use_rac_replay {
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        
        return nil;
    }] replay];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者%@",x);
        
    }];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者%@",x);
        
    }];
}

/**
 throttle节流：当某个信号发送比较频繁时，可以使用节流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出。
 */
+ (void)use_rac_throttle {
    RACSubject *signal = [RACSubject subject];
//    _signal = signal;
    
    // 节流，在一定时间（1秒）内，不接收任何信号内容，过了这个时间（1秒）获取最后发送的信号内容发出。
    [[signal throttle:1] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
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
