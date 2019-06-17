//
//  SLContryView.h
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/17.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLContryView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

+ (instancetype)countryView;

@end

NS_ASSUME_NONNULL_END
