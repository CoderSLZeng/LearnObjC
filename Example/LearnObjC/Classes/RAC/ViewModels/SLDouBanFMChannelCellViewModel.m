//
//  SLDouBanFMChannelCellViewModel.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/7/4.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLDouBanFMChannelCellViewModel.h"

#pragma mark - Views
#import "SLDouBanFMChannelCell.h"

#pragma mark - Models
#import "SLDouBanFMChannelModel.h"

@implementation SLDouBanFMChannelCellViewModel

- (void)bindView:(UIView *)view {
    SLDouBanFMChannelCell *cell = (SLDouBanFMChannelCell *)view;
    cell.textLabel.text = self.model.name;    
}


@end
