//
//  SLPickerViewModel.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/19.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLPickerViewModel.h"

#pragma mark - Frameworks
#import <ReactiveObjC/ReactiveObjC.h>

#pragma mark - Models
#import "SLCountryModel.h"

#pragma mark - Views
#import "SLContryView.h"

#pragma mark - ViewModels
#import "SLCountryViewModel.h"

@interface SLPickerViewModel()< UIPickerViewDataSource, UIPickerViewDelegate>
/** 国家数据源 */
@property (strong, nonatomic) NSArray<SLCountryViewModel *> *countryVMs;
@end

@implementation SLPickerViewModel

#pragma mark - Public
- (void)bindViewModel:(UIView *)bindView {
    UIPickerView *pickerView = (UIPickerView *)bindView;
    pickerView.dataSource = self;
    pickerView.delegate = self;
}

#pragma mark - Private
#pragma mark  UIPicker view data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.countryVMs.count;
}

#pragma mark  UIPicker view data delegate
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    SLCountryViewModel *countryViewModel = self.countryVMs[row];
    return countryViewModel.model.name;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    SLContryView *countryView = (SLContryView *)view;
    
    if (countryView == nil) {
        countryView = [SLContryView countryView];
    }
    
    SLCountryViewModel *countryViewModel = self.countryVMs[row];
    [countryViewModel bindViewModel:countryView];
    
    return countryView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 120;
}

#pragma mark  Getter
- (NSArray<SLCountryViewModel *> *)countryVMs {
    if (!_countryVMs) {
        NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"flags" ofType:@"plist"];
        NSArray *datas = [NSArray arrayWithContentsOfFile:filePath];
        
        _countryVMs = [[[[datas.rac_sequence map:^id _Nullable(id  _Nullable value) {
            // 字典 --> 模型
            SLCountryModel *model = [[SLCountryModel alloc] init];
            [model setValuesForKeysWithDictionary:value];
            return model;
        }] array].rac_sequence map:^id _Nullable(id  _Nullable value) {
            // 模型 --> 视图模型
            SLCountryViewModel *countryViewModel = [[SLCountryViewModel alloc] init];
            countryViewModel.model = value;
            return countryViewModel;
        }] array];
    }
    
    return _countryVMs;
}


@end
