//
//  SLCountryViewModel.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/19.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLCountryViewModel.h"

#pragma mark - Models
#import "SLCountryModel.h"

#pragma mark - Views
#import "SLContryView.h"

@implementation SLCountryViewModel

- (void)bindView:(UIView *)view {
    
    SLContryView *countryView = (SLContryView *)view;
    countryView.nameLabel.text = self.model.name;
    NSString *iconFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:self.model.icon ofType:nil];
    countryView.iconImageView.image = [UIImage imageWithContentsOfFile:iconFilePath];
}

@end
