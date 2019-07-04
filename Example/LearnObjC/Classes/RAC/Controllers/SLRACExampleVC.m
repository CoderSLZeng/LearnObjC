//
//  SLRACExampleVC.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/15.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

/**
 1.代替代理
 2.监听某个方法有没有调用(rac_signalForSelector:判断有没有调用某个方法)
 3.代替KVO
 4.监听事件
 5.代替通知
 6.监听文本框文字改变
 7.处理一个界面,多个请求的问题
 */

#import "SLRACExampleVC.h"

#pragma mark - Views
#import "SLCustomRACView.h"

#pragma mark - Controllers
#import "SLRACSubExampleVC.h"

#pragma mark - ViewModels
#import "SLPickerViewModel.h"

#pragma mark - Frameworks
#import <ReactiveObjC/RACReturnSignal.h>

@interface SLRACExampleVC () <SLCustomRACViewDelegate>

/** 红色视图 */
@property (weak, nonatomic) SLCustomRACView *redView;
/** 绿色视图 */
@property (weak, nonatomic) SLCustomRACView *greenView;
/** 选择国家按钮 */
@property (weak, nonatomic) UIButton *selectContryBtn;
/** 国家选择器视图 */
@property (weak, nonatomic) UIPickerView *pickerView;

/** 国家选择器视图模型 */
@property (strong, nonatomic) SLPickerViewModel *pickerViewModel;

@property (assign, nonatomic) int age;
/** 文本框 */
@property (weak, nonatomic) UILabel *label;
/** 文本输入框 */
@property (weak, nonatomic) UITextField *textField;

@property (weak, nonatomic) UIButton *modalBtn;

@end

@implementation SLRACExampleVC

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    SLRACExampleVC *vc = [super allocWithZone:zone];
    // 监听某个方法有没有调用(rac_signalForSelector:判断有没有调用某个方法)
    [[vc rac_signalForSelector:@selector(viewDidLayoutSubviews)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"【%d】%s --> %@", __LINE__, __func__, x);
        [vc setupSubviewsFrame];
    }];
    return vc;
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self useDelegateActionRedView];
    [self useRACSubjectActionGreenView];
    [self useRACCommandActionSelectContryButton];
    [self useRACObserver];
    [self useSignalForControlEvents];
    [self useRACNotification];
    [self actionTextFieldTextChange];
    [self useRACLiftSelector];
    [self userRACSignalForSelector];
    
    [self.pickerViewModel bindView:self.pickerView];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.age++;
    
    [self use_rac_flattenMap_map];
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//
//    [self setupSubviewsFrame];
//}

- (void)dealloc {
    NSLog(@"【%d】%s", __LINE__, __func__);
}

#pragma mark - Setup UI
- (void)setupSubviewsFrame {
    self.redView.frame = CGRectMake(50, 100, 100, 100);
    self.greenView.frame = CGRectMake(200, 100, 100, 100);
    self.selectContryBtn.frame = CGRectMake(50, 220, 300, 30);
    CGFloat height = 150;
    self.pickerView.frame = CGRectMake(0, self.view.frame.size.height - height * 1.5, self.view.frame.size.width, height);
    
    self.label.frame = CGRectMake(50, 270, 300, 30);
    self.textField.frame = CGRectMake(50, 320, 300, 30);
    
    self.modalBtn.frame = CGRectMake(20, 370, 300, 30);
}

- (void)updateUIWithHotData:(NSString *)hot newData:(NSString *)new {
    NSLog(@"【%d】%s --> 更新UI %@ %@", __LINE__, __func__, hot, new);
}

#pragma mark - Action
- (void)useDelegateActionRedView {
    self.redView.delegate = self;
}

#pragma mark 1.代替代理
- (void)useRACSubjectActionGreenView {

    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"【%d】%s --> 通过RACSubject信号监听了绿色的View", __LINE__, __func__);
    }];
    
    // 关联信号
    self.greenView.subject = subject;
}


#pragma mark 2.监听某个方法有没有调用
/**
 监听某个方法有没有调用(rac_signalForSelector:判断有没有调用某个方法)
 底层其实是使用rumtime的交换方法实现
 */
- (void)userRACSignalForSelector {
    [[self.greenView rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(RACTuple * _Nullable x) {
       NSLog(@"【%d】%s --> 通过rac_signalForSelector监听了绿色的View", __LINE__, __func__);
    }];
}

#pragma mark 3.代替KVO
- (void)useRACObserver {
    /**
     KVO API 使用方式1
     [self rac_valuesForKeyPath:nil observer:nil];
     [self rac_valuesAndChangesForKeyPath:nil options:nil observer:nil];
     @keypath(self, age) == @"age";
     */
    [[self rac_valuesForKeyPath:@keypath(self, age) observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"【%d】%s --> 使用方式1 age = %@", __LINE__, __func__, x);
    }];
    
    /**
     KVO API 使用方式2 （推荐）
     */
    [RACObserve(self, age) subscribeNext:^(id  _Nullable x) {
        NSLog(@"【%d】%s --> 使用方式2 age = %@", __LINE__, __func__, x);
    }];
}

#pragma mark 4.监听事件
- (void)useSignalForControlEvents {
    [[self.selectContryBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"【%d】%s --> 事件监听 %@", __LINE__, __func__, x);
    }];
    
    @weakify(self)
    [[self.modalBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        SLRACSubExampleVC *subVC = [[SLRACSubExampleVC alloc] init];
        subVC.delegateSignal = [RACSubject subject];
        [subVC.delegateSignal subscribeNext:^(id  _Nullable x) {
            NSLog(@"点击了subVC的通知按钮");
        }];
        [self presentViewController:subVC animated:YES completion:nil];
    }];
}

#pragma mark 5.代替通知
- (void)useRACNotification {
    // 监听通知
    // 管理观察者:不需要管理观察者,RAC内部管理
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RACNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"【%d】%s --> 监听到通知 %@", __LINE__, __func__, x);
    }];
    
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RACNotification" object:nil];
}

#pragma mark 6.监听文本框文字改变
- (void)actionTextFieldTextChange {
    
    // 监听方式1：Target
//    [self addTargetAction];
    
    // 监听方式2：事件
//    [self use_rac_signalForControlEvents];
    
    // 监听方式3：订阅信号
//    [self use_rac_textSignal];
    
    // 监听方式4：宏
//    [self use_rac_marco];
    
    // 监听方式5：bind
//    [self use_rac_textSignal_bind];;
    
    // 监听方式6：map
//    [self use_rac_map];
    
    // 监听方式7：use_rac_map
    [self use_rac_flattenMap];
}

- (void)textChange {
    NSLog(@"【%d】%s --> %@", __LINE__, __func__, self.textField.text);
}

#pragma mark 7.处理一个界面,多个请求的问题
- (void)useRACLiftSelector {
    // 创建请求最热数据信号
    RACSignal *hotSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 请求最热信号
        [subscriber sendNext:@"最热数据"];
        return nil;
    }];
    
    // 创建轻轻最新数据信号
    RACSignal *newSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 请求最新信号
        [subscriber sendNext:@"最新数据"];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(updateUIWithHotData:newData:) withSignals:hotSignal, newSignal, nil];
}

#pragma mark 8.rac_command
- (void)useRACCommandActionSelectContryButton {
    
    RACSubject *enabledSignal = [RACSubject subject];
    @weakify(self)
    self.selectContryBtn.rac_command = [[RACCommand alloc] initWithEnabled:enabledSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        NSLog(@"【%d】%s --> 点击了按钮%@", __LINE__, __func__, input);
        UIButton *btn = (UIButton *)input;
        btn.selected = !btn.isSelected;
        self.pickerView.hidden = !btn.isSelected;
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:input];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [[self.selectContryBtn.rac_command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        BOOL isExecuting = [x boolValue];
        [enabledSignal sendNext:@(!isExecuting)];
    }];
    
    [self.selectContryBtn.rac_command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"【%d】%s --> %@", __LINE__, __func__, x);
    }];
}

#pragma mark - 私有方法
#pragma mark 监听文本输入框文本改变
/**
 Target模式监听
 */
- (void)addTargetAction {
    [self.textField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
}

/**
 rac_signalForControlEvents模式监听
 */
- (void)use_rac_signalForControlEvents {
    [[self.textField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"【%d】%s --> %@", __LINE__, __func__, x);
    }];
}

/**
 rac_textSignal模式监听
 */
- (void)use_rac_textSignal {
    [self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"【%d】%s --> %@", __LINE__, __func__, x);
    }];
}

/**
 RAC宏 模式监听
 */
- (void)use_rac_marco {
    // RAC:给某个类的某个属性绑定一个信号，只要接收信号，就改变这个类的属性
    // 只要文本框文字改变，就会修改label的文字
    RAC(self.label, text) = self.textField.rac_textSignal;
    
    // 监听某个对象的某个属性转换为信号
    [RACObserve(self.view, center) subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

#pragma mark RAC高级用法
#pragma mark bind使用
/**
 bind 模式监听
 */
- (void)use_rac_textSignal_bind {
    [[self.textField.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
        NSLog(@"【%d】%s --> 执行bindBlock", __LINE__, __func__);
        
        return ^RACSignal *(id value, BOOL *stop) {
            // 信号一改变，就会执行，并且把值传递过来
            NSLog(@"【%d】%s --> 监听到的数据 self.textField.text = %@", __LINE__, __func__, value);
            NSString *result = [NSString stringWithFormat:@"%@%@", @"sl_", value];
            return [RACReturnSignal return:result];
        };
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"【%d】%s --> 获取到处理完的数据 self.textField.text = %@", __LINE__, __func__, x);
    }];
}

#pragma mark map使用
/**
 map 模式监听
 */
- (void)use_rac_map {
    [[self.textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        // 拦截输入文字
        NSString *result = [NSString stringWithFormat:@"sl_%@",value];
        return result;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"【%d】%s --> %@", __LINE__, __func__, x);
    }];
}

#pragma mark flattenMap使用
/**
 flattenMap 信号中的信号 模式监听
 */
- (void)use_rac_flattenMap {
    [[self.textField.rac_textSignal flattenMap:^ RACSignal * (NSString * value) {
        NSString *result = [NSString stringWithFormat:@"sl_%@", value];
        // 拦截输入文字
        return [RACReturnSignal return:result];
        
    }] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
        
    }];
}

#pragma mark flattenMap和Map组合使用
- (void)use_rac_flattenMap_map {
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
            return [NSString stringWithFormat:@"SL:%@",value];
        }];
        
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    [signalOfSignals sendNext:signal];
    [signal sendNext:@(self.age)];
}

#pragma mark Getter
- (SLCustomRACView *)redView {
    if (!_redView) {
        SLCustomRACView *redView = [[SLCustomRACView alloc] init];
        redView.backgroundColor = [UIColor redColor];
        [self.view addSubview:redView];
        _redView = redView;
    }
    
    return _redView;
}

- (SLCustomRACView *)greenView {
    if (!_greenView) {
        SLCustomRACView *greenView = [[SLCustomRACView alloc] init];
        greenView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:greenView];
        _greenView = greenView;
    }
    return _greenView;
}

- (UIButton *)selectContryBtn {
    if (!_selectContryBtn) {
        UIButton *selectContryBtn = [[UIButton alloc] init];
        selectContryBtn.backgroundColor = [UIColor blueColor];
        [selectContryBtn setTitle:@"点击显示选择国家选择器" forState:UIControlStateNormal];
        [selectContryBtn setTitle:@"点击隐藏选择国家选择器" forState:UIControlStateSelected];
        [selectContryBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self.view addSubview:selectContryBtn];
        _selectContryBtn = selectContryBtn;
    }
    return _selectContryBtn;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.hidden = YES;
        [self.view addSubview:pickerView];
        _pickerView = pickerView;
    }
    
    return _pickerView;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:label];
        _label = label;
    }
    return _label;
}

- (UITextField *)textField {
    if (!_textField) {
        UITextField *textField = [[UITextField alloc] init];
        textField.backgroundColor = [UIColor lightGrayColor];
        textField.placeholder = @"请输入...";
        [self.view addSubview:textField];
        _textField = textField;
    }
    return _textField;
}

- (UIButton *)modalBtn {
    if (!_modalBtn) {
        UIButton *modalBtn = [[UIButton alloc] init];
        modalBtn.backgroundColor = [UIColor blueColor];
        [modalBtn setTitle:@"Modal to SLRACSubExampleVC" forState:UIControlStateNormal];
        [modalBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self.view addSubview:modalBtn];
        _modalBtn = modalBtn;
    }
    
    return _modalBtn;
}

- (SLPickerViewModel *)pickerViewModel {
    if (!_pickerViewModel) _pickerViewModel = [[SLPickerViewModel alloc] init];
    return _pickerViewModel;
}

#pragma mark - SLCustomRACViewDelegate
- (void)customRACViewDidTouchesBegan:(SLCustomRACView *)view {
    NSLog(@"【%d】%s --> 通过代理监听点击了红色的View", __LINE__, __func__);
}

@end
