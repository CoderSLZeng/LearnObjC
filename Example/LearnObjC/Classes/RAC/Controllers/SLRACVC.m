//
//  SLRACVC.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/15.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLRACVC.h"

#pragma mark - Frameworks
#import <ReactiveObjC/ReactiveObjC.h>

#pragma mark - Views
#import "SLCustomRACView.h"
#import "SLContryView.h"

#pragma mark - Models
#import "SLCountryModel.h"

@interface SLRACVC () <SLCustomRACViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
/** 国家选择器视图 */
@property (strong, nonatomic) UIPickerView *pickerView;
/** 国家数据源 */
@property (strong, nonatomic) NSArray<SLCountryModel *> *contries;
@end

@implementation SLRACVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self useRACSignal];
//    [self useRACSubject];
//    [self useRACReplaySubject];
    
    [self setupUI];
    
//    [self useRACTuple]
    [self useRACMulticastConnection];
    
}

#pragma mark - Setup UI
- (void)setupUI {
    [self useDelegateAction];
    [self useRACSubjectAction];
    [self setupContryBtn];
    
}

- (void)setupContryBtn {
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(50, 300, 300, 30);
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"点击显示选择国家选择器" forState:UIControlStateNormal];
    [btn setTitle:@"点击隐藏选择国家选择器" forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(didContryButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


- (void)useRACMulticastConnection {
    
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

- (void)loadData:(void(^)(id))success {
    NSLog(@"加载数据");
}

/**
 RAC集合:异步线程处理数据
 */
- (void)useRACTuple {
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

- (void)useRACSubjectAction {
    SLCustomRACView *view = [[SLCustomRACView alloc] init];
    view.backgroundColor = [UIColor greenColor];
    view.frame = CGRectMake(200, 100, 100, 100);
    [self.view addSubview:view];
    
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"通过RACSubject信号监听了绿色的View");
    }];
    
    // 关联信号
    view.subject = subject;
}

- (void)useDelegateAction {
    SLCustomRACView *view = [[SLCustomRACView alloc] init];
    view.backgroundColor = [UIColor redColor];
    view.frame = CGRectMake(50, 100, 100, 100);
    [self.view addSubview:view];
    view.delegate = self;
}

#pragma mark - Action
- (void)didContryButton:(UIButton *)btn {
    
    btn.selected = !btn.isSelected;
    self.pickerView.hidden = !btn.isSelected;
}

#pragma mark - Getter
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        CGFloat height = 150;
        _pickerView.frame = CGRectMake(0, self.view.frame.size.height - height * 1.5, self.view.frame.size.width, height);
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [self.view addSubview:_pickerView];
    }
    
    return _pickerView;
}

- (NSArray<SLCountryModel *> *)contries {
    if (!_contries) {
        NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"flags" ofType:@"plist"];
        NSArray *datas = [NSArray arrayWithContentsOfFile:filePath];
        
        _contries = [[datas.rac_sequence map:^id _Nullable(id  _Nullable value) {
            SLCountryModel *model = [[SLCountryModel alloc] init];
            [model setValuesForKeysWithDictionary:value];
            return model;
        }] array];
        
    }
    
    return _contries;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.contries.count;
}

#pragma mark - UIPickerViewDataDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    SLCountryModel *countryModel = self.contries[row];
    return countryModel.name;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    SLContryView *countryView = (SLContryView *)view;
    
    if (countryView == nil) {
        countryView = [SLContryView countryView];
    }
    
    SLCountryModel *countryModel = self.contries[row];
    countryView.nameLabel.text = countryModel.name;
    NSString *iconFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:countryModel.icon ofType:nil];
    countryView.iconImageView.image = [UIImage imageWithContentsOfFile:iconFilePath];
    
    return countryView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 120;
}


#pragma mark - SLCustomRACViewDelegate
- (void)customRACViewDidTouchesBegan:(SLCustomRACView *)view {
    NSLog(@"通过代理监听点击了红色的View");
}

#pragma mark - Use RAC

/**
  RACReplaySubject：无需注意订阅和发送信号的顺序
 */
- (void)useRACReplaySubject {
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
- (void)useRACSubject {
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
 RACSignal：信号
 
 订阅RACSignal，自动创建RACSubscriber，由RACSubscriber发送信号消息
 
 RACSignal：只能订阅，不能发送
 RACSignal：只有一个订阅者
 */
- (void)useRACSignal {
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



@end
