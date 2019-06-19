//
//  SLRACVC.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/15.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLRACVC.h"



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
    
    [self setupUI];
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








@end
