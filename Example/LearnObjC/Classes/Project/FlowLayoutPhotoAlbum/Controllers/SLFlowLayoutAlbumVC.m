//
//  SLFlowLayoutAlbumVC.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/7/4.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLFlowLayoutAlbumVC.h"

#pragma mark ViewModels
#import "SLFlowLayoutAlbumViewModel.h"

@interface SLFlowLayoutAlbumVC ()

@property (strong, nonatomic) SLFlowLayoutAlbumViewModel *albumViewModel;
@end

@implementation SLFlowLayoutAlbumVC

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.albumViewModel bindView:self.view];
}

#pragma mark - Getter
- (SLFlowLayoutAlbumViewModel *)albumViewModel {
    if (!_albumViewModel) _albumViewModel = [[SLFlowLayoutAlbumViewModel alloc] init];
    
    return _albumViewModel;
}


@end
