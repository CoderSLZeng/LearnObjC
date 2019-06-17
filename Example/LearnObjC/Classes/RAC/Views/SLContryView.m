//
//  SLContryView.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/17.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLContryView.h"

@implementation SLContryView

+ (instancetype)countryView {
    return [[NSBundle bundleForClass:self]
            loadNibNamed:@"SLContryView"
            owner:nil
            options:nil].firstObject;
}

@end
