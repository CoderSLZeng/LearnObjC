//
//  SLRACExampleVC.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/15.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLRACExampleVC.h"

#pragma mark - Views
#import "SLCustomRACView.h"
#import "SLContryView.h"

#pragma mark - Models
#import "SLCountryModel.h"

@interface SLRACExampleVC () <SLCustomRACViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

/** 红色视图 */
@property (weak, nonatomic) SLCustomRACView *redView;
/** 绿色视图 */
@property (weak, nonatomic) SLCustomRACView *greenView;
/** 选择国家按钮 */
@property (weak, nonatomic) UIButton *selectContryBtn;
/** 国家选择器视图 */
@property (weak, nonatomic) UIPickerView *pickerView;
/** 国家数据源 */
@property (strong, nonatomic) NSArray<SLCountryModel *> *contries;

@property (assign, nonatomic) int age;

@end

@implementation SLRACExampleVC

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self useDelegateActionRedView];
    [self useRACSubjectActionGreenView];
    [self useRACCommandActionSelectContryButton];
    [self useRACObserver];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.age++;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.redView.frame = CGRectMake(50, 100, 100, 100);
    self.greenView.frame = CGRectMake(200, 100, 100, 100);
    self.selectContryBtn.frame = CGRectMake(50, 250, 300, 30);
    CGFloat height = 150;
    self.pickerView.frame = CGRectMake(0, self.view.frame.size.height - height * 1.5, self.view.frame.size.width, height);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - Action
- (void)useDelegateActionRedView {
    self.redView.delegate = self;
}

- (void)useRACSubjectActionGreenView {
    
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"通过RACSubject信号监听了绿色的View");
    }];
    
    // 关联信号
    self.greenView.subject = subject;
}

- (void)useRACCommandActionSelectContryButton {
    
    RACSubject *enabledSignal = [RACSubject subject];
    @weakify(self)
    self.selectContryBtn.rac_command = [[RACCommand alloc] initWithEnabled:enabledSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        NSLog(@"点击了按钮%@", input);
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
        NSLog(@"%@", x);
    }];
}

- (void)useRACObserver {
    /**
     KVO API 使用方式1
     [self rac_valuesForKeyPath:nil observer:nil];
     [self rac_valuesAndChangesForKeyPath:nil options:nil observer:nil];
     @keypath(self, age) == @"age";
     */
    [[self rac_valuesForKeyPath:@keypath(self, age) observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"使用方式1 age = %@", x);
    }];
    
    /**
     KVO API 使用方式2 （推荐）
     */
    [RACObserve(self, age) subscribeNext:^(id  _Nullable x) {
        NSLog(@"使用方式2 age = %@", x);
    }];
}

#pragma mark - Getter
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
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.hidden = YES;
        [self.view addSubview:pickerView];
        _pickerView = pickerView;
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











@end
