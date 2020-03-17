//
//  SLFlowLayoutAlbumViewModel.m
//  LearnObjC
//
//  Created by CoderSLZeng on 2019/7/4.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLFlowLayoutAlbumViewModel.h"

#import "SLFlowLayout.h"

#pragma mark Views
#import "SLPhotoCell.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
static NSString * const ID = @"photoCell";

@interface SLFlowLayoutAlbumViewModel () <UICollectionViewDataSource>

@end

@implementation SLFlowLayoutAlbumViewModel

- (void)bindView:(UIView *)view {
    
    // 利用布局就做效果 => 如何让cell尺寸不一样 => 自定义流水布局
    // 流水布局:调整cell尺寸
    SLFlowLayout *layout = ({
        
        SLFlowLayout *layout = [[SLFlowLayout alloc] init];
        
        // 设置尺寸
        layout.itemSize = CGSizeMake(160, 160);
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat margin = (kScreenW - 160) * 0.5;
        layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
        // 设置最小行间距
        layout.minimumLineSpacing = 50;
        layout;
    });
    
    // UICollectionView使用注意点
    // 1.创建UICollectionView必须要有布局参数
    // 2.cell必须通过注册
    // 3.cell必须自定义,系统cell没有任何子控件
    // 创建UICollectionView:黑色
    UICollectionView *collectionView = ({
        
        UICollectionView *collectionView =  [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor brownColor];
        collectionView.center = view.center;
        collectionView.bounds = CGRectMake(0, 0, view.bounds.size.width, 200);
        collectionView.showsHorizontalScrollIndicator = NO;
        [view addSubview:collectionView];
        
        // 设置数据源
        collectionView.dataSource = self;
        
        collectionView;
    });
    
    // 注册cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SLPhotoCell class])  bundle:nil] forCellWithReuseIdentifier:ID];
}

#pragma mark - UICollection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SLPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    NSString *imageName = [NSString stringWithFormat:@"%ld",indexPath.item + 1];
    cell.photoView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

@end
