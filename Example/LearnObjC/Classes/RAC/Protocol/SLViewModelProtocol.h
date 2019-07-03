//
//  SLViewModelProtocol.h
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/6/19.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#ifndef SLViewModelProtocol_h
#define SLViewModelProtocol_h

#import <UIKit/UIKit.h>

@protocol SLViewModelProtocol <NSObject>

@optional
- (void)bindView:(UIView *)view;

@end

#endif /* SLViewModelProtocol_h */
